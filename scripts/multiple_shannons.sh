#! /usr/bin/env bash

N=4

if [ "$1" != "" ]; then
    N=$1
fi

echo $N
for i in $(seq 1 $N); do
    xfce4-terminal -e 'zsh -c "hn_ssh shannon"'
done
