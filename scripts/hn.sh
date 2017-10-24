#! /usr/bin/env bash

if [ "$1" == "" ] ;
then
    HN="hn";
else
    HN="$1";
fi

LOCAL_CONFIG='~/.config/master_thesis'
MONGO_HOST=$(ssh $HN "cat $LOCAL_CONFIG/mongodb_host")
MONGO_PORT=$(ssh $HN "cat $LOCAL_CONFIG/mongodb_port")
SACRED_BOARD_PORT=$(ssh $HN "cat $LOCAL_CONFIG/sacredboard_port")

JUPYTER_HOST=$(ssh $HN "cat $LOCAL_CONFIG/jupyter_host")
JUPYTER_PORT=$(ssh $HN "cat $LOCAL_CONFIG/jupyter_port")

echo "MONGODB: $MONGO_HOST:$MONGO_PORT"
echo "JUPYTER: $JUPYTER_HOST:$JUPYTER_PORT"

CMD="ssh \
	-L 27017:$MONGO_HOST:$MONGO_PORT \
	-L 5000:$MONGO_HOST:$SACRED_BOARD_PORT \
	-L 8000:$JUPYTER_HOST:$JUPYTER_PORT \
	$HN -t zsh
	"

echo $CMD
$CMD
