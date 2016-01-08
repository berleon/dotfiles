#! /usr/bin/env bash

DEVICE='cpu'

if [ -e '/dev/nvidiactl' ]; then
    DEVICE='gpu0'
fi

cat <<END
[global]
floatX = float32
device = $DEVICE
allow_gc = False
optimizer_including = conv_meta

[nvcc]
fastmath = True

[dnn.conv]
algo_fwd = time_once
algo_bwd_data = time_once
algo_bwd_filter = time_once
END

