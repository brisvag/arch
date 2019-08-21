#!/usr/bin/env python3

import subprocess
from pathlib import Path


repo_name = 'brisvag'
pkgs_dir = Path(__file__).parent / 'pkgs'
repo_dir = Path(__file__).parent / 'repo'


def build_packages():
    for dir in pkgs_dir.iterdir():
        if dir.is_dir():
            subprocess.run(['makepkg', '-fc'], cwd=dir)
            # put everything in the repo directory
            subprocess.run(f'mv *.tar.xz ../../repo/', cwd=dir, shell=True)


def update_db():
    for tar in repo_dir.iterdir():
        if tar.match(f'{repo_name}-*.pkg.tar.xz'):
            subprocess.run(f'repo-add {repo_name}.db.tar.xz {tar.name}', cwd=repo_dir, shell=True)


def rename_db(backwards=False):
    # move tar databases to correct names (without .tar.xz)
    # hacky but necessary, because symlinks, somehow, are not resolved
    db = repo_dir / f'{repo_name}.db'
    files = repo_dir / f'{repo_name}.files'
    db_tar = repo_dir / f'{repo_name}.db.tar.xz'
    files_tar = repo_dir / f'{repo_name}.files.tar.xz'
    if backwards:
        db_tar, db = db, db_tar
        files_tar, files = files, files_tar
    if db_tar.is_file() and files_tar.is_file():
        db_tar.rename(db)
        files_tar.rename(files)


if __name__ == '__main__':
    rename_db(backwards=True)
    build_packages()
    update_db()
    rename_db()
