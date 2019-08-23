#!/bin/bash

# this hook updates the dotfiles of the current user to the latest version

# detect user. If root, don't copy dotfiles.
user="${SUDO_USER}"
if [[ "${user}" == "" ]]; then
  exit 0
fi

home="/home/${user}"
dotfiles="${home}/dotfiles"

# if there are no dotfiles at all, exit the hook
if [[ -d "${dotfiles}" ]]; then
  cd "${dotfiles}"
else
  exit 0

directories=($(find ./ -mindepth 1 -type d))
files=($(find ./ -type f))

cd "${home}"

# make missing directories
for dir in ${directories}; do
  if [[ -d "${dir}" ]]; then
	continue
  else
	mkdir "${dir}"
  fi
done

# backup if needed, and make necessary links
for file in ${files}; do
#  if [[ -h ${file} ]]; then
#	continue
  if [[ -f "${home}/${file}" ]]; then
	mv "${home}/${file}" "${home}/${file}.pacbak"
  fi
  ln -s "${dotfiles}/${file}" "${home}/${file}"
  # change permissions to user (-h to avoiud following the symlink)
  chown ${user}:users "${dotfiles}/${file}"
  chown -h ${user}:users "${home}/${file}"
done
