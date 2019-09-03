#!/bin/bash

(
cd CG

MARTINIZE=/home/lorenzo/local/martinize2/bin/martinize2
$MARTINIZE -f ../AA/aa-EMv.pdb -x cg.pdb -o cg.top -elastic -ss CT1111HHHHHHHHHHHHHHHHHH2222CCCEEEEEEEEESSSCEEEEEEEEEECCCSSCCCSEECTTEEEEEEEECCSSSCCCCEEEEEEEEETTSEEEEEEEEECSCTTTCCCEEEEEEEESCCCCC13332CCCCCSCCEECSSEEEEEEEETTEEEEEEECSSSEEEEEEEEEEC -p backbone -ff martini30 -merge A,B,C,D,E,F,G,H
#$MARTINIZE -f ../AA/aa-EMv.pdb -x cg.pdb -o cg.top -elastic -ss CT1111HHHHHHHHHHHHHHHHHH2222CCCEEEEEEEEESSSCEEEEEEEEEECCCSSCCCSEECTTEEEEEEEECCSSSCCCCEEEEEEEEETTSEEEEEEEEECSCTTTCCCEEEEEEEESCCCCC13332CCCCCSCCEECSSEEEEEEEETTEEEEEEECSSSEEEEEEEEEEC -p backbone -ff martini22 -merge A,B,C,D,E,F,G,H
)


mkdir topol
cp ~/martini3/* topol/
#cp ~/martini2/* topol/

(
mcd RUN01

python2.7 /home/lorenzo/scripts/insane.py -f ../CG/cg.pdb -o start.gro -p topol.top -pbc cubic -d 6.0 -l DOPC -u DOPC -dm -8 -z 14.5 -salt 0.15 -sol W -orient
#python2.7 /home/lorenzo/scripts/insane.py -f ../CG/cg.pdb -o start.gro -p topol.top -pbc cubic -d 6.0 -l DOPC:1 -l DPSM:1 -u DOPC:1 -u DPSM:1 -dm -8 -z 14.5 -salt 0.15 -sol W -orient


# Fix topology martini3
sed -i 's/#include "martini.itp"/#include "..\/topol\/martini_v3.0.3.itp"\n#include "..\/topol\/martini_v3.0_ions.itp"\n#include "..\/topol\/martini_v3.0_phospholipids.itp"\n#include "..\/topol\/martini_v3.0_solvents.itp"\n\n#include "molecule_0.domELNEDIN.itp"/' topol.top
sed -i 's/Protein        1/molecule_0       1/' topol.top
sed -i 's/W /WN/' topol.top
sed -i 's/NA+/TNA/' topol.top
sed -i 's/CL-/TCL/' topol.top

# Fix topology martini2
sed -i 's/#include "martini.itp"/#include "..\/topol\/martini_v2.2.itp"\n#include "..\/topol\/martini_v2.0_ions.itp"\n#include "..\/topol\/martini_v2.0_solvents.itp"\n#include "..\/topol\/martini_v2.0_DOPC_02.itp"\n#include "..\/topol\/martini_v2.0_DPSM_01.itp"\n\n#include "molecule_0.domELNEDIN.itp"/' topol.top
sed -i 's/Protein        1/molecule_0       1/' topol.top
# need to add antifreeze water!

cp ../CG/molecule_0.domELNEDIN.itp .
cp /home/lorenzo/mdps/* .

if [ ! -f index.ndx ]; then
    echo "Index is missing!"
    exit 1
fi


rm -rf *.tpr *.xtc \#* step*

source /usr/local/gromacs-2018.1/bin/GMXRC
rm -rf *.tpr
gmx grompp -f em.mdp -p topol.top -c start.gro -r start.gro -maxwarn 10 -o em.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm em 

echo -ne 13\\nname 16 Membrane\\n14\|15\\nname 17 Solvent\\nq\\n | gmx make_ndx -f em.gro       #martini3, no DPSM
echo -ne 13\|14\\nname 17 Membrane\\n15\|16\\nname 18 Solvent\\nq\\n | gmx make_ndx -f em.gro       #martini3, with DPSM
#echo -ne 13\\nname 17 Membrane\\n14\|15\|16\\nname 18 Solvent\\nq\\n | gmx make_ndx -f em.gro      #martini2, no DPSM
#echo -ne 13\|14\\nname 18 Membrane\\n15\|16\|17\\nname 19 Solvent\\nq\\n | gmx make_ndx -f em.gro      #martini2, with DPSM

gmx grompp -f eq1.mdp -p topol.top -c em.gro -r start.gro -maxwarn 10 -o eq1.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm eq1 
gmx grompp -f eq2.mdp -p topol.top -c eq1.gro -r start.gro -maxwarn 10 -o eq2.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm eq2 
gmx grompp -f eq3.mdp -p topol.top -c eq2.gro -r start.gro -maxwarn 10 -o eq3.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm eq3 
gmx grompp -f eq4.mdp -p topol.top -c eq3.gro -r start.gro -maxwarn 10 -o eq4.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm eq4 
gmx grompp -f eq5.mdp -p topol.top -c eq4.gro -maxwarn 10 -o eq5.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm eq5 
gmx grompp -f eq6.mdp -p topol.top -c eq5.gro -maxwarn 10 -o eq6.tpr
gmx mdrun -nt 11 -rdd 1.4 -v -deffnm eq6 

gmx grompp -f md.mdp -c eq6.gro -p topol.top -n index.ndx -maxwarn 10 -o md.tpr
gmx mdrun -v -nt 11 -rdd 1.4 -deffnm md


#rm -rf \#* step*


# vmd start.gro em.trr eq1.xtc eq2.xtc eq3.xtc eq4.xtc eq5.xtc eq6.xtc
