#!/bin/bash

rm -rf bonds
mkdir bonds 
rm -rf angles
mkdir angles
rm -rf dihedrals
mkdir dihedrals

NBONDS=$(($(cat bonds.ndx | wc -l) / 2 ))
NANGLES=$(($(cat angles.ndx | wc -l) / 2 ))
NDIHEDRALS=$(($(cat dihedrals.ndx | wc -l) / 2 ))

IBOND=0

while [ $IBOND -lt $NBONDS ]
    do
    echo $IBOND | gmx distance -f mapped.xtc -n bonds.ndx -s cg.tpr -oall bonds/bond_$IBOND.xvg
    gmx analyze -f bonds/bond_$IBOND.xvg -dist bonds/distr_$IBOND.xvg -bw 0.001
    rm -rf \#*
    let IBOND=$IBOND+1
    done

IANGLE=0

while [ $IANGLE -lt $NANGLES ]
    do
    echo $IANGLE | gmx angle -f mapped.xtc -n angles.ndx -ov angles/angle_$IANGLE.xvg
    gmx analyze -f angles/angle_$IANGLE.xvg -dist angles/distr_$IANGLE.xvg -bw 1.0
    rm -rf \#*
    let IANGLE=$IANGLE+1
    done

IDIHEDRAL=0

while [ $IDIHEDRAL -lt $NDIHEDRALS ]
    do
    echo $IDIHEDRAL | gmx angle -type dihedral -f mapped.xtc -n dihedrals.ndx -ov dihedrals/dihedral_$IDIHEDRAL.xvg
    gmx analyze -f dihedrals/dihedral_$IDIHEDRAL.xvg -dist dihedrals/distr_$IDIHEDRAL.xvg -bw 1.0
    rm -rf \#*
    let IDIHEDRAL=$IDIHEDRAL+1
    done

