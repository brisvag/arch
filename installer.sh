#!/usr/bin/env bash

# Installer script for arch-linux
# Based on mdaffin's script at https://github.com/mdaffin/arch-pkgs

# run with: curl -sL https://git.io/brisvag-arch | bash

# raise error on undefined variables and properly handle errorcodes in pipes
set -uo pipefail
# trap errors and tell some more info about it; then exit
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
# separators used to split sequences: remove space and keep \t and \n
IFS=$'\n\t'

# get some decent logging
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

# set ntp as active
timedatectl set-ntp true

# update mirrorlist
