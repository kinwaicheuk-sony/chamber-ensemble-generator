import os
import glob
import argparse
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor, as_completed

def extract_tar_file(tar_file, output_dir):
    os.system(f'tar -xf {tar_file} --use-compress-prog=bzip2 -C {output_dir}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--data_dir', type=str, default=None, metavar='N',
                        help='the directory containing all the zip files downloaded from the GCS.')
    parser.add_argument('--output_dir', type=str, default=None, metavar='N',
                        help='the directory for outputting the extracted dataset.')
    parser.add_argument('--num_workers', type=int, default=32, metavar='N',
                        help='number of parallel workers for extraction.')
    parser.add_argument('--start_file', type=int, default=1, metavar='N',
                        help='the starting file number for extraction.')

    args = parser.parse_args()

    data_dir = args.data_dir
    output_dir = args.output_dir
    num_workers = args.num_workers
    start_file = args.start_file

    tar_files = []
    for data_type in ['main_dataset']:  # use only 'main_dataset'
        for split in ['train', 'test', 'valid']:
            os.makedirs(os.path.join(output_dir, data_type, split), exist_ok=True)
            all_tar_files = glob.glob(os.path.join(data_dir, data_type, split, '*.tar.bz2'))
            # Filter tar files to start from the specified start_file number
            filtered_tar_files = [f for f in all_tar_files if int(os.path.basename(f).split('.')[0]) >= start_file]
            tar_files.extend(filtered_tar_files)
            # print(filtered_tar_files)
    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        futures = [executor.submit(extract_tar_file, tar_file, os.path.join(output_dir, 'main_dataset', split))
                   for tar_file in tar_files]
        for future in tqdm(as_completed(futures), total=len(futures)):
            future.result()
