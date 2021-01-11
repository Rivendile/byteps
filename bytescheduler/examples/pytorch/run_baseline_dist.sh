export USE_BYTESCHEDULER=0
#export BYTESCHEDULER_QUEUE_TYPE=0
# export BYTESCHEDULER_TUNING=1
export BYTESCHEDULER_PARTITION=8000000
export BYTESCHEDULER_CREDIT=8000000
export BYTESCHEDULER_CREDIT_TUNING=0
export BYTESCHEDULER_PARTITION_TUNING=0
# export BYTESCHEDULER_TIMELINE=timeline_baseline.json
# export BYTESCHEDULER_DEBUG=1
export PS_VERBOSE=1

horovodrun -np 16 -H localhost:8,3.85.80.174:8 -p 2022 python pytorch_horovod_benchmark.py --model vgg16 --num-batches-per-iter 10 --num-iters 10 --train-dir /home/cluster/data/imagenet