#!/bin/bash

DIR=../models/ssi/inat17/space2vec_grid

ENC=Space2Vec-grid

DATA=inat_2017
META=ebird_meta
EVALDATA=val

DEVICE=cuda:2

LR=0.02
LAYER=1
HIDDIM=256
FREQ=128
MINR=0.005
MAXR=360
EPOCH=29
ACT=leakyrelu

RATIO=0.1
SAMPLE=random-fix

loop=1

for RATIO in $(seq 0.1 0.1 1.0)
do
    for RUN in {1..10}
    do
        for loop in {1..10}
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
            --device $DEVICE \
            --batch_size 512 \
            --ssi_no_prior F
        done
    done
done



