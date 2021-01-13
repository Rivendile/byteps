#!/bin/bash

# setup SSH
cd ~/.ssh
touch config
echo "Host *" >>~/.ssh/config
echo "    ForwardAgent yes" >>~/.ssh/config
echo "Host *" >>~/.ssh/config
echo "    StrictHostKeyChecking no" >>~/.ssh/config
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/config
chmod 600 ~/byteps/bytescheduler/bytescheduler-20201004.pem
chmod 600 ~/byteps/bytescheduler/bytescheduler-0105.pem
id2translate=$(cat ~/.ssh/id_rsa.pub)
ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.24.229 "echo $id2translate >>~/.ssh/authorized_keys"
ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.17.207 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.19.77 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.21.62 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.23.78 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.24.191 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.28.63 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-20201004.pem ubuntu@172.31.18.47 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.47.10 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.42.159 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.38.169 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.36.138 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.37.230 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.33.120 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.42.177 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.33.212 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.42.64 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.42.140 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.47.217 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.39.185 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.39.7 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.39.40 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.42.65 "echo $id2translate >>~/.ssh/authorized_keys"
#ssh -i ~/byteps/bytescheduler/bytescheduler-0105.pem ubuntu@172.31.42.102 "echo $id2translate >>~/.ssh/authorized_keys"

cd ~/
# setup docker and connect to container
# mxnet ps ssh t4 myps
docker login -u rivendile -p zhyh19980824
docker pull rivendile/bsc-mxnet-ps-ssh
nvidia-docker run -it --gpus all --ipc=host --name mlnet-analysis --network host -v /home/ubuntu/byteps:/home/cluster/byteps --detach 8565e522a91c
docker_container_id=$(docker ps -aqf "name=mlnet-analysis")
docker cp $docker_container_id:/home/cluster/.ssh ~/mlnet_analysis_ssh
ssh -i ~/mlnet_analysis_ssh/id_rsa -p 2022 cluster@localhost
