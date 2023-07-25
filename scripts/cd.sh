#!/bin/sh

CHOICE=$(find $HOME -follow -maxdepth 1 -type d | fzf)

if ! [ -z "$CHOICE" ]; then
	cd $CHOICE
fi

