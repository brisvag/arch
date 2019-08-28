#!/usr/bin/env python3

import subprocess
from pathlib import Path
import argparse
import sys


repo_name = 'brisvag'
pkgs_dir = Path(__file__).parent / 'pkgs'
repo_dir = Path(__file__).parent / 'repo'


def parse_input():
    """
    parses user input and provides nice options
    :return: a dictionary of packages to update and a list of packages to remove
    """
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--add', dest='add', default=[], nargs='+',
                        help='list of packages to update. Use `all` to update everything')
    parser.add_argument('-r', '--remove', dest='remove', default=[], nargs='*',
                        help='list of packages to remove')
    args = parser.parse_args()
    if len(sys.argv[1:]) == 0:
        parser.print_help()
        sys.exit()

    update = {}

    if args.add == ['all']:
        for dir in pkgs_dir.iterdir():
            if dir.is_dir():
                update[dir.absolute().name] = dir
    elif args.add:
        for pkg in args.add:
            update[pkg] = pkgs_dir / pkg

    # check if inputs are sane
    for pkg, dir in update.items():
        if not dir.is_dir():
            raise FileNotFoundError(f'chosen package ({pkg}) does not exist')

    return update, args.remove


def build_packages(update_list):
    """
    rebuilds the requested packages and moves the tar files to the `repo` directory
    :param update_list: dictionary with packages to update
    """
    for pkg, dir in update_list.items():
        subprocess.run(['makepkg', '-fc'], cwd=dir)
        # put the package in the repo directory
        for tar in dir.iterdir():
            if tar.match(f'{repo_name}-*.pkg.tar.xz'):
                subprocess.run(f'mv {tar.name} ../../repo/', cwd=dir, shell=True)


def delete_old_packages(update_list, remove_list):
    """
    deletes old tar files
    :param update_list: dictionary with packages to update
    """
    for pkg in list(update_list.keys()) + remove_list:
        for tar in repo_dir.iterdir():
            if tar.match(f'{repo_name}-{pkg}-*.pkg.tar.xz'):
                subprocess.run(f'rm {tar.name}', cwd=repo_dir, shell=True)


def update_db(update_list, remove_list):
    """
    updates the database files
    :param update_list: dictionary with packages to update
    :param remove_list: list of packages to remove
    """
    for pkg, dir in update_list.items():
        for tar in repo_dir.iterdir():
            if tar.match(f'{repo_name}-{pkg}-*.pkg.tar.xz'):
                subprocess.run(f'repo-add {repo_name}.db.tar.xz {tar.name}', cwd=repo_dir, shell=True)
    for pkg in remove_list:
        subprocess.run(f'repo-remove {repo_name}.db.tar.xz {repo_name}-{pkg}', cwd=repo_dir, shell=True)


def rename_db(backwards=False):
    """
    renames the database files to allow for automation
    :param backwards: reverses the operation
    """
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
    update_list, remove_list = parse_input()
    rename_db(backwards=True)
    delete_old_packages(update_list, remove_list)
    build_packages(update_list)
    update_db(update_list, remove_list)
    rename_db()
