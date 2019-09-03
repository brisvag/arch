#!/usr/bin/env bash

# raise error on undefined variables and properly handle errorcodes in pipes
set -uo pipefail

# trap errors and tell some more info about it; then exit
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

# separators used to split sequences: remove space and keep \t and \n
IFS=$'\n\t'
