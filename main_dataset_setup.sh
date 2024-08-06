#!/bin/bash

# Red color code
RED='\033[0;31m'
# Green color code
GREEN='\033[0;32m'
# No color code
NC='\033[0m'


bash data_download/download_cocochorales_full_parallelv2.sh

python data_download/extract_tars_parallel.py \
--data_dir cocochorales_tiny_v1_zipped \
--output_dir full \
--num_workers 32 \
--start_file 1

# Predefined file size in bytes
size_test=782336
size_train=6242304
size_valid=782336

# Files to check
declare -A files
files["full/main_dataset/test"]=$size_test
files["full/main_dataset/train"]=$size_train
files["full/main_dataset/valid"]=$size_valid

for file_path in "${!files[@]}"; do
    expected_size=${files[$file_path]}
    actual_size=$(stat -c%s "$file_path")

    num_files=$(ls $file_path | wc -l)
    
    if [[ "$actual_size" -eq "$expected_size" ]]; then
        echo -e "${GREEN} $file_path has a size of $actual_size. And $num_files tracks ${NC}"
    else
        echo -e "${RED}The file size of $file_path does not match the predefined size. Expected: $expected_size, Actual: $actual_size${NC}"
    fi
done

# move the file 
chmod 755 full
mv full ../

# change the permission
chmod 755 ../