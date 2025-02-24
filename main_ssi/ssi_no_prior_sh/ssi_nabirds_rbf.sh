#!/bin/bash

DIR=../models/ssi/na_rbf/

ENC=rbf

# DATA=birdsnap
DATA=nabirds
# DATA=inat_2018
# DATA=nabirds
META=ebird_meta
# META=orig_meta
EVALDATA=test

DEVICE=cuda:2

LR=0.0005
LAYER=1
HIDDIM=512
FREQ=64
MINR=0.005
#MAXR=360
EPOCH=29
ACT=relu

KERNELSIZE=2
ANCHOR=100

RATIO=0.1
SAMPLE=random-fix

loop=1


for RATIO in $(seq 0.1 0.1 1.0)
do
    for RUN in {1..10}
    do
        #for loop in {1..10}
        #do
        python3 train_unsuper.py \
            --ssi_run_time $RUN \
            --ssi_loop $loop \
            --train_sample_method $SAMPLE \
            --spa_enc_type $ENC \
            --meta_type $META \
            --dataset $DATA \
            --eval_split $EVALDATA \
            --frequency_num $FREQ \
            --min_radius $MINR \
            --num_hidden_layer $LAYER \
            --hidden_dim $HIDDIM \
            --spa_f_act $ACT \
            --lr $LR \
            --model_dir $DIR \
            --num_epochs $EPOCH \
            --train_sample_ratio $RATIO \
            --device $DEVICE \
            --num_rbf_anchor_pts $ANCHOR \
            --rbf_kernel_size $KERNELSIZE
        #done
    done
done



