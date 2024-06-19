import os
import numpy as np
import pandas as pd
import shutil
from PIL import Image

WIDTH = 384
HEIGHT = 384

input_datasets = '/home/ralf/git_repositories/multi-task-strengthen-weaken/2_pipeline/6_create_statistically_representative_dataset/store'
input_images = '/home/ralf/DATA/ISIC-BASED/images'
output_resized_images = '/home/ralf/DATA/ISIC-BASED/images384_384'

def create_output_folders(output_resized_images):
    seeds = np.array([1970, 1972, 2008, 2019, 2024])
    for seed in seeds:
        folder_path = os.path.join(output_resized_images, str(seed))
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)
    
        metadata_folder_path = os.path.join(folder_path, 'metadata')
        if not os.path.exists(metadata_folder_path):
            os.makedirs(metadata_folder_path)

def save_image(original, resized):
    if not os.path.exists(resized):
        img = Image.open(original)
        img_resized = img.resize((WIDTH, HEIGHT))
        img_resized.save(skin_lesion_file_resized)

create_output_folders(output_resized_images)

filenames = os.listdir(input_datasets)
for filename in filenames:
    parts = filename.split('_')
    seed = parts[4].split('.')[0]
    source_file = input_datasets + '/' + filename
    destination_dir = output_resized_images + '/' + str(seed) + '/metadata'
    shutil.copy(source_file, destination_dir)

    df = pd.read_csv(source_file)
    for isic_id in df['isic_id']:
        skin_lesion_file_original = input_images + '/' + isic_id + '.JPG'
        skin_lesion_file_resized = output_resized_images + '/' + str(seed) + '/' + isic_id + '.JPG'
        save_image(skin_lesion_file_original, skin_lesion_file_resized)