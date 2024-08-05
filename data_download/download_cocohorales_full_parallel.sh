#!/bin/bash

mkdir -p cocochorales_tiny_v1_zipped/main_dataset/{train,valid,test}
cd cocochorales_tiny_v1_zipped

# download md5
wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/cocochorales_md5s.txt

# download main dataset in parallel
seq 1 96 | xargs -P 8 -I {} wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/main_dataset/train/{}.tar.bz2 -P main_dataset/train
