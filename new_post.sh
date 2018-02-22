#!/bin/bash
if [ "$#" -le 0 ]; then
	echo "Usage: $(basename "$0") <filename.md>" >&2
	exit 1
fi
hugo new --editor=vim "posts/$1"
