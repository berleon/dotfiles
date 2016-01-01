#! /usr/bin/env bash

DOT_DIR=$(realpath dotfiles/)
DOTFILES=$(find $DOT_DIR -type f)
HOME=$(realpath ~)
echo $DOTFILES
echo "############################# Link dotfiles ##################################"
for file in $DOTFILES; do
    DEST=$HOME/.${file#$DOT_DIR/}
    echo ".${file#$DOT_DIR/}"
    ln -sf $file $DEST
done

