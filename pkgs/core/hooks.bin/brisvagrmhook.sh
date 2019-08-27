#!/bin/bash

# this hook restores the dotfiles of the current user to the pre-installation version

# which packages were just removed? (passed though stdin)
pkgs=$(cat)

# detect user. If root, just exit
user="${SUDO_USER}"
if [[ "${user}" == "" ]]; then
  exit 0
fi

home="/home/${user}"
dotfiles="${home}/dotfiles"

# if there are no dotfiles at all, exit the hook
[[ -d "${dotfiles}" ]] || exit 0

# get list of dotfiles owned by the removed packages
files=($(find $(pacman -Ql ${pkgs} | awk '{print $2}') -maxdepth 0 -type f | \
       xargs -n 1 realpath --relative-to="${dotfiles}"))
# restore backupped packages
for file in ${files}; do
  if [[ -f "${home}/${file}.pacbak" ]]; then
    mv "${home}/${file}.pacbak" "${home}/${file}"
  fi
  # change permissions to user (-h to avoid following symlinks)
  chown -h ${user}:users "${home}/${file}"
done
