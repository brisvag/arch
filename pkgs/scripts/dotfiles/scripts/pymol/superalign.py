#! /usr/bin/env python

# ACHTUNG: it's hardcoded on the resname

from pymol import cmd


def superalign(target, ligand_recogniser):
    receptors = cmd.get_names(selection='not *{}*'.format(ligand_recogniser))
    cmd.create('target', '{}'.format(target))

    for r in receptors:
        ligands = cmd.get_names(selection='{}_*{}*'.format(r, ligand_recogniser))
        for l in ligands:
            cmd.create('{}_superaligned'.format(l), 'None')
            cmd.create('TMP', '{} or {}'.format(r, l))
            cmd.align('TMP and name ca', 'target')
#            states = cmd.count_states('{}_superaligned'.format(r))
#            states += 1
#            cmd.create('{}_superaligned'.format(r), 'TMP and resname UNL', '0', '{}'.format(states))
            cmd.create('{}_superaligned'.format(l), 'TMP and resname UNL')
            cmd.delete('TMP')
            cmd.delete('{}'.format(l))
        cmd.delete('{}'.format(r))


cmd.extend('superalign', superalign)
