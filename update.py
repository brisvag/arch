#!/usr/bin/env python3

import subprocess
from pathlib import Path

repo_dir = Path(__file__).parent / 'repo'

for dir in repo_dir.iterdir():
    if dir.is_dir():
        subprocess.run(['makepkg', '-fc'], cwd=dir)

subprocess.run('repo-add brisvag.db.tar.xz ./*/*.tar.xz', cwd=repo_dir, shell=True)
