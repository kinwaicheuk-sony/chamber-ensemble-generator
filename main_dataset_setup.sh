#!/bin/bash

bash data_download/download_cocochorales_full_parallelv2.sh

python data_download/extract_tars_parallel.py \
--data_dir cocochorales_tiny_v1_zipped \
--output_dir full \
--num_workers 32 \
--start_file 1