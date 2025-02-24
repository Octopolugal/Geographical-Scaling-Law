#!/bin/bash

DIR=../models/ssi/inat17/space2vec_theory

ENC=Space2Vec-theory

# DATA=birdsnap
# DATA=nabirds
DATA=inat_2017
# DATA=nabirds
META=ebird_meta
# META=orig_meta
EVALDATA=val

DEVICE=cuda:2

LR=0.02
LAYER=1
HIDDIM=256
FREQ=64
MINR=0.1
MAXR=360
EPOCH=29
ACT=leakyrelu

RATIO=0.1
SAMPLE=random-fix

loop=1

for RATIO in 0.01 0.05 0.1 0.5 1.0
do
    for RUN in {1..5}
    do
        #for loop in {1..5}
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
            --batch_size 512
        #done
    done
done



