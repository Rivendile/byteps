./dist_server.sh  2 2 0 0 0  python train_imagenet.py --network resnet --num-layers 50 --benchmark 1 --kv-store dist_sync --batch-size 32 --disp-batches 2 --num-examples 384 --num-epochs 1 --gpus 0 --role server
