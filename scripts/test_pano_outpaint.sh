#!/bin/bash -l

SCRIPTPATH=$(dirname $(readlink -f "$0"))
PROJECT_DIR="${SCRIPTPATH}"

export PYTHONPATH=$PROJECT_DIR:$PYTHONPATH

n_nodes=1
n_gpus_per_node=1
torch_num_workers=0
batch_size=1
exp_name="test_mp3d_outpaint=$(($n_gpus_per_node * $n_nodes * $batch_size))"

CUDA_VISIBLE_DEVICES='0' python -u ./test.py configs/pano_generation_outpaint.yaml \
    ${data_cfg_path} \
    ${main_cfg_path} \
    --exp_name=${exp_name} \
    --gpus=${n_gpus_per_node} --num_nodes=${n_nodes} --accelerator="cuda" --strategy="ddp" \
    --batch_size=${batch_size} --num_workers=${torch_num_workers} \
    --mode test \
    --ckpt_path  /root/data/pre-trained-models/mvdiffusion/pano_outpaint.ckpt
