#!/bin/bash

# This scripts updates the repo's version of dotfiles to my home
# configuration, in case I made any changes to the dotfiles which are not
# reflected in the packages

# raise error on undefined variables and properly handle errorcodes in pipes
set -uo pipefail
# trap errors and tell some more info about it; then exit
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# TODO: ugly and hardcoded. Any better way?
repodir="/home/brisvag/git/arch/pkgs"

cd "${repodir}"
packages=$(find ./ -mindepth 1 -maxdepth 1 -type d)

for package in ${packages}; do
  if [[ -d "${package}/dotfiles" ]]; then
    cd "${package}/dotfiles"
    files=$(find ./ -type f)
    for file in ${files}; do
      if [[ -f "/home/brisvag/${file}" ]]; then
        cp "/home/brisvag/${file}" "${file}"
      fi
    done
    cd "${repodir}"
  fi
done
