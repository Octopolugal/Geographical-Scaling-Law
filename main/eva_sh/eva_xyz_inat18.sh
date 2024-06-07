#!/bin/bash

DIR=../models/rff_test/

ENC=xyz

DATA=inat_2018
META=ebird_meta
EVALDATA=val

DEVICE=cuda:1

LR=0.0005
LAYER=1
HIDDIM=512
FREQ=64
MINR=0.005
MAXR=1
################# Please set “--num_epochs” to be 0, because you do not want further train the model. #################
EPOCH=0

ACT=relu
RATIO=1.0

################# Now you have a set of hyperparameter fixed, so cancel the loops #################
################# Please set “–save_results” to be T AND “--load_super_model” to be T #################


python3 train_unsuper.py \
    --save_results T\
    --load_super_model T\
    --spa_enc_type $ENC \
    --meta_type $META\
    --dataset $DATA \
    --eval_split $EVALDATA \
    --frequency_num $FREQ \
    --max_radius $MAXR \
    --min_radius $MINR \
    --num_hidden_layer $LAYER \
    --hidden_dim $HIDDIM \
    --spa_f_act $ACT \
    --unsuper_lr 0.1 \
    --lr $LR \
    --model_dir $DIR \
    --num_epochs $EPOCH \
    --train_sample_ratio $RATIO \
    --device $DEVICE 

