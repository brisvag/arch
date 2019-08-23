#!/bin/bash

# hardcoded username
user="brisvag"

cd /home/${user}/dotfiles/

directories=($(find ./ -mindepth 1 -type d))
files=($(find ./ -type f))

cd /home/${user}

# make missing directories
for dir in ${directories}; do
  if [[ -d ${dir} ]]; then
	continue
  else
	mkdir ${dir}
  fi
done

# backup if needed, and make necessary links
for file in ${files}; do
#  if [[ -h ${file} ]]; then
#	continue
  if [[ -f ${file} ]]; then
	mv ${file} ${file}.pacbak
  fi
  ln -s /home/${user}/dotfiles/${file} ${file}
  # change permissions to user
  chown ${user}:users dotfiles/${file}
  chown -h ${user}:users ${file}
done
