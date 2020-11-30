export USE_BYTESCHEDULER=1
export BYTESCHEDULER_QUEUE_TYPE=2
# export BYTESCHEDULER_TUNING=1
export BYTESCHEDULER_PARTITION=8000000
export BYTESCHEDULER_CREDIT=8000000
export BYTESCHEDULER_CREDIT_TUNING=0
export BYTESCHEDULER_PARTITION_TUNING=1
 export BYTESCHEDULER_TIMELINE=timeline_bs_fifo.json
# export BYTESCHEDULER_DEBUG=1
export PS_VERBOSE=1
export BYTESCHEDULER_ROOT_IP=localhost
export BYTESCHEDULER_ROOT_PORT=8000

horovodrun -np 8 -H localhost:4,3.93.217.10:4 -p 2022 python pytorch_horovod_benchmark.py --model resnet50 --num-batches-per-iter 100 --num-iters 5