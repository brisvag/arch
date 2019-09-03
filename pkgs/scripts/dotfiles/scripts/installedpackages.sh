#!/bin/bash

# print the names of all packages that were explicitly installed

ignoregrp="base base-devel xorg brisvag-all"
ignorepkg=""

comm -23 <(pacman -Qqen | sort) \
	<(echo $ignorepkg | tr ' ' '\n' | cat <(pacman -Sqg $ignoregrp) - | sort -u)

