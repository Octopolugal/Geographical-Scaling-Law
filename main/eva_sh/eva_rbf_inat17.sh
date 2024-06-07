#!/bin/bash

DIR=../models/rff_test/

ENC=rbf

DATA=inat_2017
META=ebird_meta
EVALDATA=val

DEVICE=cuda:2

LR=0.01
LAYER=1
HIDDIM=512
FREQ=64
MINR=0.001
MAXR=1
ANCHOR=500
KERNELSIZE=2
################# Please set “--num_epochs” to be 0, because you do not want further train the model. #################
EPOCH=100

ACT=relu
RATIO=1.0

################# Now you have a set of hyperparameter fixed, so cancel the loops #################
################# Please set “–save_results” to be T AND “--load_super_model” to be T #################


python3 train_unsuper.py \
    --save_results T\
    --load_super_model F\
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
    --device $DEVICE \
    --num_rbf_anchor_pts $ANCHOR \
    --rbf_kernel_size $KERNELSIZE

