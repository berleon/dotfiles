#! /usr/bin/env bash

HOME=$(realpath ~)
FILE=$(realpath $1)
DOTFILES=$(realpath dotfiles)
WITHOUT_HOME=${FILE#$HOME/}
DIR_PART=$(dirname $WITHOUT_HOME)
echo "Adding $WITHOUT_HOME to dotfiles"
echo $DIR_PART
mkdir -p $DOTFILES/$DIR_PART
cp $FILE $DOTFILES/${WITHOUT_HOME}
