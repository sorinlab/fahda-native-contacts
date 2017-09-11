#!/usr/bin/perl

# ------------------------------------------------------------------------------
# Create all properly titled F@H PDB's from log file
# Original Author: Eric J. Sorin, written on 08/2013
# ------------------------------------------------------------------------------

use strict;

# GLOBAL VARIABLES
$pdbmax      = 100000000;
$maxpdb      = 0;
$numpdb      = 0;
$currentpdbs = 0;
$numlines    = 0;
$oldrun      = -1;
$oldclone    = -1;

$usage = "\nUsage: \.\/make_FAH-PDBs_from_logfile.pl  \[Project \#\]  \[Max PDB's (optional)\]
Run this script in the location of the F\@H PROJ\$X directories ...
And don't forget the good old `usegromacs33` before running this script\!\n\n";

$proj = chomp($ARGV[0]) || die "$usage\n";
$maxpdb = $ARGV[1];
if ($maxpdb > 0) { $pdbmax = $maxpdb; }
$outfile = "make_FAH-PDBs_$proj.log";
open(my $OUT, '>', $outfile);

# READ IN THE LOGFILE AND GO TO THE P/R/C DIRECTORY
$homedir = `pwd`;
chomp $homedir;
$logfile = "/home/server/FAHdata/PKNOT/log$proj";
open(my $LOG, '<', $logfile) || die "ERROR: An error occurred while trying to open $logfile: $!\n\n";

while (defined($line = <$LOG>) && $numpdb <= $pdbmax) {
    $numlines++;
    for ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
    @input = split(/ /, $line);
    $logproj = $input[0];
    if ($logproj != $proj) {
        die "PROJ $logproj found is not the same a PROJ $proj expected\!";
    }
    $run   = $input[1];
    $clone = $input[2];
    $time  = $input[3];     # time in ps
    $frame = $time / 100;

    # change directory only if the current
    # run or clone # has changed in the log file
    if ($run != $oldrun || $clone != $oldclone) {
        print $OUT "$proj $run $clone\t$currentpdbs created\n";
        $currentpdbs = 0;
        $workdir     = "$homedir/PROJ$proj/RUN$run/CLONE$clone/";
        chdir $workdir;
        $test = `pwd`;
        chomp $test;
        print $OUT "Working on directory $test ...\n";
        `rm *.pdb *# 2> /dev/null`;
    }

    # now make the PDB files!!!
    $xtcfile = "P${proj}_R${run}_C$clone.xtc";
    $pdbfile = "p${proj}_r${run}_c${clone}_f$frame.pdb";
    if (-e $xtcfile) {
        $command = "echo 1 1 | trjconv -s frame0.tpr -f $xtcfile -dump $time -o $pdbfile";
        `$command 2> /dev/null`;
        if (-e $pdbfile) {
            $numpdb++;
            $currentpdbs++;
        }
        else {
            print $OUT "FAILED to create new pdb file $pdbfile\n";
        }
    }

    $oldclone = $clone;
    $oldrun   = $run;
}

close($LOG);
close($OUT);
