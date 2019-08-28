#!/usr/bin/env python3

# This scripts updates the repo's version of dotfiles to my home
# configuration, in case I made any changes to the dotfiles which are not
# reflected in the packages

import subprocess
from pathlib import Path
import getpass


repo_name = 'brisvag'
pkgs_dir = Path(__file__).parent / 'pkgs'
repo_dir = Path(__file__).parent / 'repo'


for pkg in pkgs_dir.iterdir():
    dotfiles = pkg / 'dotfiles'
    if dotfiles.is_dir():
        for file in dotfiles.rglob('**/*'):
            relpath = file.relative_to(dotfiles)
            user = getpass.getuser()
            homefile = f'/home/{user}' / relpath
            if homefile.is_file():
                subprocess.run(f'cp {homefile} {relpath}', cwd=dotfiles, shell=True)
