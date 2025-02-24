#!/bin/bash

DIR=../models/ssi/inat17/sphere2vec_dfs

ENC=Sphere2Vec-dfs

# DATA=birdsnap
# DATA=nabirds
DATA=inat_2017
# DATA=nabirds
META=ebird_meta
# META=orig_meta
EVALDATA=val

DEVICE=cuda:2

LR=0.01
LAYER=1
HIDDIM=512
FREQ=8
MINR=0.01
MAXR=1
EPOCH=29
ACT=relu

RATIO=0.1
SAMPLE=random-fix

loop=1


for RATIO in 0.02 0.03 0.04 0.06 0.07 0.08 0.09
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



