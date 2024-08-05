#!/bin/bash

mkdir cocochorales_tiny_v1_zipped
cd cocochorales_tiny_v1_zipped

# download md5
wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/cocochorales_md5s.txt

# Function to check md5 and download if necessary
check_and_download() {
  local md5sum=$1
  local filepath=$2
  local url=$3

  if [ -f "$filepath" ]; then
    local current_md5=$(md5sum "$filepath" | awk '{ print $1 }')
    if [ "$current_md5" == "$md5sum" ]; then
      echo "$filepath exists and checksum matches. Skipping download."
      return
    else
      echo "$filepath exists but checksum does not match. Redownloading."
    fi
  else
    echo "$filepath does not exist. Downloading."
  fi

  wget -O "$filepath" "$url"
}

# Function to get md5 checksum from file
get_md5sum() {
  local filepath=$1
  grep "$filepath" cocochorales_md5s.txt | awk '{ print $1 }'
}

# download main dataset
mkdir main_dataset
mkdir main_dataset/train
mkdir main_dataset/valid
mkdir main_dataset/test

for i in $(seq 1 1 96); do
  filepath="main_dataset/train/$i.tar.bz2"
  url="https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/$filepath"
  target=$(get_md5sum "$filepath")
  if [ -f "$filepath" ]; then
    current_md5=$(md5sum "$filepath" | awk '{ print $1 }')
    echo "target $target"
    echo "file $current_md5"
    if [ "$current_md5" == "$target" ]; then
      echo "$filepath exists and checksum matches. Skipping download."
      return
    else
      echo "$filepath exists but checksum does not match. Redownloading."
    fi  
  else
    echo "$filepath does not exist. Downloading."
  fi
done
  # wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/main_dataset/train/"$i".tar.bz2 -P main_dataset/train
# done
# for i in $(seq 1 1 12); do
#   wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/main_dataset/valid/"$i".tar.bz2 -P main_dataset/valid
# done
# for i in $(seq 1 1 12); do
#   wget -nc https://storage.googleapis.com/magentadata/datasets/cocochorales/cocochorales_full_v1_zipped/main_dataset/test/"$i".tar.bz2 -P main_dataset/test
# done