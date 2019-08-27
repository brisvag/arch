#!/bin/bash

# this hook updates the dotfiles of the current user to the latest version

# which packages were just installed? (passed though stdin)
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

# make missing directories
cd "${dotfiles}"
directories=($(find ./ -mindepth 1 -type d))
cd "${home}"
for dir in ${directories}; do
  if [[ -d "${dir}" ]]; then
	continue
  else
	mkdir "${dir}"
  fi
done

# get list of dotfiles owned by the installed packages
files=($(find $(pacman -Ql ${pkgs} | awk '{print $2}') -maxdepth 0 -type f | \
       xargs -n 1 realpath --relative-to="${dotfiles}"))
# backup files if needed, and make necessary links
for file in ${files}; do
  # if the file exist and is not a symlink, make a backup
  if [[ -f "${home}/${file}" ]] && ! [[ -h "${home}/${file}" ]]; then
    mv "${home}/${file}" "${home}/${file}.pacbak"
  fi
  # then create a symlink (-f to overwrite)
  ln -sf "${dotfiles}/${file}" "${home}/${file}"
  # change permissions to user (-h to avoid following the symlink)
  chown ${user}:users "${dotfiles}/${file}"
  chown -h ${user}:users "${home}/${file}"
done
