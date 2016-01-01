#! /usr/bin/env bash

DOT_DIR=$(realpath dotfiles/)
DOTFILES=$(find $DOT_DIR -type f)
HOME=$(realpath ~)
BACKUP=$(realpath backup)

echo "############################# Link dotfiles ##################################"
for file in $DOTFILES; do
    DEST=$HOME/.${file#$DOT_DIR/}
    echo ".${file#$DOT_DIR/}"
    mkdir -p `dirname $DEST`
    if [ ! -L "$DEST" ]; then
        BACKUP_DEST=$BACKUP/${DEST#$HOME}
        mkdir -p `dirname $BACKUP_DEST`
        cp $DEST $BACKUP_DEST
    fi
    ln -sf $file $DEST
done

