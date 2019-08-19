#!/usr/bin/env python3

import subprocess
from pathlib import Path


repo_name = 'brisvag'
repo_dir = Path(__file__).parent / 'repo'


def build_packages():
    for dir in repo_dir.iterdir():
        if dir.is_dir():
            subprocess.run(['makepkg', '-fc'], cwd=dir)


def make_db():
    subprocess.run(f'repo-add {repo_name}.db.tar.xz ./*/*.tar.xz', cwd=repo_dir, shell=True)
    # replace symlinks with the real files
    db_dest = repo_dir / f'{repo_name}.db'
    files_dest = repo_dir / f'{repo_name}.files'
    db_old = repo_dir / f'{repo_name}.db.tar.xz'
    files_old = repo_dir / f'{repo_name}.files.tar.xz'
    db_old.rename(db_dest)
    files_old.rename(files_dest)


if __name__ == '__main__':
    build_packages()
    make_db()
