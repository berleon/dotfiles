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

TENSORBOARD_HOST=$(ssh $HN "cat $LOCAL_CONFIG/tensorboard_host")
TENSORBOARD_PORT=$(ssh $HN "cat $LOCAL_CONFIG/tensorboard_port")

echo "MONGODB: $MONGO_HOST:$MONGO_PORT"
echo "JUPYTER: $JUPYTER_HOST:$JUPYTER_PORT"
echo "TENSORBOARD: $TENSORBOARD_HOST:$TENSORBOARD_PORT"

CMD="ssh \
	-L 27017:$MONGO_HOST:$MONGO_PORT \
	-L 5000:$MONGO_HOST:$SACRED_BOARD_PORT \
	-L 8000:$JUPYTER_HOST:$JUPYTER_PORT \
	-L 6006:$TENSORBOARD_HOST:$TENSORBOARD_PORT \
    -L 7000:gpu9:7000 \
	$HN -t zsh
	"

echo $CMD
$CMD
