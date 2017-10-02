# pknot-native-contacts

Native contact characterization for pseudoknot structures

## Logfile generation

A logfile contains information about all data points of every simulation.

An "all-frame" `pdb` file is generated for each simulation using `trjconv`. Parsing the "TITLE" lines in this file gives all the possible frames within a simulation.

```bash
# `echo 1` to select the "protein" group
$ echo 1 | trjconv -s frame0.tpr -f $xtc_file -o $pdb_file
$ head $pdb_file
REMARK    GENERATED BY TRJCONV
TITLE     41361 t= 10500.00000
REMARK    THIS IS A SIMULATION BOX
CRYST1   75.058   75.058   75.058  90.00  90.00  90.00 P 1           1
MODEL      107
ATOM      1  H5T RG5     1      42.420  55.930  40.590  1.00  0.00
ATOM      2  O5' RG5     1      43.060  55.840  39.880  1.00  0.00
ATOM      3  C5' RG5     1      44.060  56.830  39.900  1.00  0.00
ATOM      4 H5'1 RG5     1      44.170  57.320  40.870  1.00  0.00
ATOM      5 H5'2 RG5     1      43.820  57.610  39.170  1.00  0.00
```

```bash
$ usegromacs33
$ ./logfile-make.pl PROJ1797 output.log
$ head output.log
1797       0       1         0
1797       0       1       100
1797       0       1       200
1797       0       1       300
1797       0       1       400
...
```

## RMSD & Rg calculation

Calculate RMSD & Rg for each frame in all simulations and output to logfile. The script will not regenerate the `*.xvg` files if they already exist.

```bash
$ usegromacs33
$ ./calc-rmsd-rg.pl PROJ1797 index.ndx topol.gro output.log
$ head output.log
1797       0       1         0      0.034     11.335
1797       0       1       100      3.492     12.696
1797       0       1       200      3.266     12.475
1797       0       1       300      3.324     12.576
1797       0       1       400      3.330     12.642
...
```

## All Atom-to-atom Contact Calculation

Calculate all atom-to-atom contacts given a maximum atomic distance (in Angstrom) and residue separation. Output: a concetenated `.con` file.

See [all-contacts/README.md](all-contacts/README.md) for details on how to run the scripts.

## Native Contact Calculation

TODO: More info here ([more details](native-contacts/README.md))

## Native Contact Normalization

TODO: More info here ([Percent Native Contact](http://folding.cnsm.csulb.edu/wiki/index.php/Percent_Native_Contact))