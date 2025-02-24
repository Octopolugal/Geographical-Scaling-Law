#!/bin/bash

DIR=../models/ssi/inat17/sphere2vec_sphereC+

ENC=Sphere2Vec-sphereC+

# DATA=birdsnap
# DATA=nabirds
DATA=inat_2017
# DATA=nabirds
META=ebird_meta
# META=orig_meta
EVALDATA=val

DEVICE=cuda:1

LR=0.0001
LAYER=1
HIDDIM=1024
FREQ=32
MINR=0.01
MAXR=1
EPOCH=29
ACT=relu

RATIO=0.1
SAMPLE=random-fix

loop=1
# need ratio 0.5 runtime 4-5 & ratio 1.0
for RATIO in 0.5
do
    for RUN in {4..5}
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



