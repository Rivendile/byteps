# dmlc_num_server, dmlc_num_worker, ps_slicer, use_bytescheduler, bytescheduler_queue_type, kvstore_map_kind, kvstore_map_model
./dist_worker.sh 4 4 0 0 0 2 1 python train_imagenet.py --network vgg --num-layers 16 --benchmark 1 --kv-store dist_sync --batch-size 128 --disp-batches 100 --num-examples 26880 --num-epochs 1 --gpus 0,1,2,3 --role worker
