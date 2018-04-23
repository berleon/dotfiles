#! /usr/bin/env bash

if [ "$1" == "" ] ;
then
    HN="bommel";
    echo "No host given using default: $HN"
else
    HN="$1";
fi

LOCAL_CONFIG='~/.config/docker_ports'
# MONGO_HOST=$(ssh $HN "cat $LOCAL_CONFIG/mongodb_host")
MONGO_PORT=$(ssh $HN "cat $LOCAL_CONFIG/mongodb_port")
SACRED_BOARD_PORT=$(ssh $HN "cat $LOCAL_CONFIG/sacredboard_port")

# JUPYTER_HOST=$(ssh $HN "cat $LOCAL_CONFIG/jupyter_host")
JUPYTER_PORT=$(ssh $HN "cat $LOCAL_CONFIG/jupyter_port")

# TENSORBOARD_HOST=$(ssh $HN "cat $LOCAL_CONFIG/tensorboard_host")
TENSORBOARD_PORT=$(ssh $HN "cat $LOCAL_CONFIG/tensorboard_port")

echo "MONGODB: $MONGO_HOST:$MONGO_PORT"
echo "JUPYTER: $JUPYTER_HOST:$JUPYTER_PORT"
echo "TENSORBOARD: $TENSORBOARD_HOST:$TENSORBOARD_PORT"

CMD="ssh \
	-L 27017:localhost:$MONGO_PORT \
	-L 5000:localhost:$SACRED_BOARD_PORT \
	-L 8000:localhost:$JUPYTER_PORT \
	-L 6006:localhost:$TENSORBOARD_PORT \
	$HN -t zsh
	"

echo $CMD
$CMD
