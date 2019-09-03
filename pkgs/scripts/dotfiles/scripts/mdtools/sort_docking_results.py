#!/usr/bin/env python

import os
import operator
from pymol import cmd


# d = sys.argv[1]
d = '/home/brisvag/tmp/bellossom/docking/restricted/working'

sorter = []

for filename in os.listdir(d):
    if filename.endswith('.log') and 'ferulic' in filename:
        with open(f"{d}/{filename}") as f:
            table = False
            for l in f.readlines():
                if l.startswith('Writing'):
                    break
                if table:
                    sorter.append((filename.rsplit('.', 1)[0], l.split()[0], l.split()[1]))
                if l.startswith('---'):
                    table = True
                    continue

sorter.sort(key=operator.itemgetter(2), reverse=True)

for i in range(len(sorter)):
    cmd.create('sorted_ligands', f"{sorter[i][0]}_superaligned", str(sorter[i][1]), i+1)
    print(f"{i+1}) {sorter[i][0]}, conformation {sorter[i][1]}. Energy: {sorter[i][2]} Kcal/mol.")
