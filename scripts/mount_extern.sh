#! /usr/bin/env zsh

set -e
CMD="sudo mount --options rw --uuid  522e10b7-f7f7-4aed-9ccd-596d87f91a6a /mnt/extern"
echo $CMD
eval $CMD