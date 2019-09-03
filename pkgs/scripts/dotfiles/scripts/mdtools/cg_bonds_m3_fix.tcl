#   execute cg_bonds on martini 3 allowing elastic network

proc cg_bonds_m3_fix {itp top} {
    exec 
    exec awk '/(Rubber|RUBBER)/,/^$/{if($3=="6") $3="1"} 1' $itp > EN_fix.itp
    exec sed -ne "s/$itp/EN_fix.itp/" $top > EN_fix.top
    exec gmx
}

cg_bonds_m3_fix [lindex $argv 0] [lindex $argv 1]
cg_bonds -gmx /usr/local/gromacs-2018.1/bin/gmx -topoltype "elastic" -tpr E_fix.tpr -cutoff 10
