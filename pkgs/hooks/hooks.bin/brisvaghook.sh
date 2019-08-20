#!/bin/bash

cd /home/brisvag/dotfiles/

directories=($(find ./ -mindepth 1 -type d))
files=($(find ./ -type f))

cd /home/brisvag/

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
  ln -s dotfiles/${file} ${file}
done

