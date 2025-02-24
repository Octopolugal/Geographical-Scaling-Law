#!/bin/bash

DIR=../models/ssi/sphere2vec_sphereC+

ENC=Sphere2Vec-sphereC+

# DATA=birdsnap
# DATA=nabirds
DATA=inat_2018
# DATA=nabirds
META=ebird_meta
# META=orig_meta
EVALDATA=val

DEVICE=cuda:2

LR=0.0005
LAYER=1
HIDDIM=1024
FREQ=64
MINR=0.001
MAXR=1
EPOCH=21
ACT=leakyrelu

RATIO=0.1
SAMPLE=random-fix


for RATIO in $(seq 0.1 0.1 1.0)
do
    for RUN in {1..5}
    do
        for loop in {1..5}
        do
            python3 train_unsuper.py \
                --ssi_run_time $RUN \
                --ssi_loop $loop \
                --train_sample_method $SAMPLE \
                --spa_enc_type $ENC \
                --meta_type $META \
                --dataset $DATA \
                --eval_split $EVALDATA \
                --frequency_num $FREQ \
                --max_radius $MAXR \
                --min_radius $MINR \
                --num_hidden_layer $LAYER \
                --hidden_dim $HIDDIM \
                --spa_f_act $ACT \
                --lr $LR \
                --model_dir $DIR \
                --num_epochs $EPOCH \
                --train_sample_ratio $RATIO \
                --device $DEVICE
        done
    done
done



