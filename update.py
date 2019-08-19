#!/usr/bin/env python3

import subprocess
from pathlib import Path


repo_name = 'brisvag'
pkgs_dir = Path(__file__).parent / 'pkgs'
repo_dir = Path(__file__).parent / 'repo'


def build_db():
    for dir in pkgs_dir.iterdir():
        if dir.is_dir():
            subprocess.run(['makepkg', '-fc'], cwd=dir)
            # put everything in the repo directory
            subprocess.run(f'mv *.tar.xz ../../repo/', cwd=dir, shell=True)


def fix_db():
    for tar in repo_dir.iterdir():
        if tar.match('*.tar.xz'):
            subprocess.run(f'repo-add {repo_name}.db.tar.xz {tar.name}', cwd=repo_dir, shell=True)
    # replace symlinks with the real files. Hacky but necessary, cause symlinks somehow are not resolved
    db_dest = repo_dir / f'{repo_name}.db'
    files_dest = repo_dir / f'{repo_name}.files'
    db_old = repo_dir / f'{repo_name}.db.tar.xz'
    files_old = repo_dir / f'{repo_name}.files.tar.xz'
    db_old.rename(db_dest)
    files_old.rename(files_dest)


if __name__ == '__main__':
    build_db()
    fix_db()
