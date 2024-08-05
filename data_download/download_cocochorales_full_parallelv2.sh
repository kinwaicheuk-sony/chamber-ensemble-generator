#!/bin/bash

mkdir -p cocochorales_tiny_v1_zipped/main_dataset/{train,valid,test}
cd cocochorales_tiny_v1_zipped

# download md5
wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/cocochorales_md5s.txt

# Function to check md5 and download if necessary
check_and_download() {
  local dataset=$1
  local file_number=$2
  local filepath="main_dataset/${dataset}/${file_number}.tar.bz2"
  local url="https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/${filepath}"
  
  local md5sum=$(grep "${filepath}" cocochorales_md5s.txt | awk '{ print $1 }')

  if [ -f "${filepath}" ]; then
    local current_md5=$(md5sum "${filepath}" | awk '{ print $1 }')
    if [ "${current_md5}" == "${md5sum}" ]; then
      echo "${filepath} exists and checksum matches. Skipping download."
      return
    else
      echo "${filepath} exists but checksum does not match. Redownloading."
    fi
  else
    echo "${filepath} does not exist. Downloading."
  fi

  wget -O "${filepath}" "${url}"
}

export -f check_and_download

# download main dataset in parallel
seq 1 96 | xargs -P 8 -I {} bash -c 'check_and_download "train" "$@"' _ {}
seq 1 12 | xargs -P 8 -I {} bash -c 'check_and_download "valid" "$@"' _ {}
seq 1 12 | xargs -P 8 -I {} bash -c 'check_and_download "test" "$@"' _ {}
