#!/bin/bash

DIR=../models/ssi/sphere2vec_sphereM+

ENC=Sphere2Vec-sphereM+

DATA=nabirds
META=ebird_meta
EVALDATA=test

DEVICE=cuda:3

LR=0.0137194382868686
LAYER=1
HIDDIM=256
FREQ=32
MINR=0.0000174775405742231
MAXR=1
EPOCH=29
ACT=leakyrelu

RATIO=0.1
SAMPLE=random-fix


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
                --ssi_no_prior F
        done
    done
done



