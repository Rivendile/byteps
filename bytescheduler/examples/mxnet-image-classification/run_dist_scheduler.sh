./dist_scheduler.sh 1 2  python train_imagenet.py --network vgg --num-layers 16 --benchmark 1 --kv-store dist_sync --batch-size 128 --disp-batches 100 --num-examples 14080 --num-epochs 1 --gpus 0,1,2,3 --role scheduler
