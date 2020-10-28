#!/bin/bash
# set -x
if [ $# -lt 3 ]; then
    echo "usage: $0 num_servers num_workers bin [args..]"
    exit -1;
fi

export USE_BYTESCHEDULER=0
#export MXNET_CUDNN_AUTOTUNE_DEFAULT=0
# export BYTESCHEDULER_TUNING=1
# export BYTESCHEDULER_PARTITION=512000
# export BYTESCHEDULER_CREDIT=4096000
#export BYTESCHEDULER_TIMELINE=timeline.json
# export BYTESCHEDULER_DEBUG=1

export DMLC_NUM_SERVER=$1
shift
export DMLC_NUM_WORKER=$1
shift
bin=$1
shift
arg="$@"

# start the scheduler
export DMLC_PS_ROOT_URI='172.31.86.107'
export DMLC_PS_ROOT_PORT=8000
export DMLC_ROLE='scheduler'
MXNET_PROFILER_AUTOSTART=1 ${bin} ${arg} &


wait
