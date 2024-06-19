# coding: utf-8

# Introduction

"""
This code allows you to generate a training, validation and test dataset, based on a static population distribution,
from an existing dataset.
"""
import numpy as np
import os
import sys
# TODO: generate input csvs for biased datasets (input for matlab code, find optimal solution for biased dataset)
from environment_variables import EnvVarsSingleton
import pandas as pd

NAME = '6_create_train_val_test_datasets.py'
PROJECT = 'HINTS'

MALIGNANT = 1
BENIGN = 0

train_frac = 0.7
val_frac = 0.175
test_frac = 0.125

def random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, target, seed):
    if n_test > 0:
        random_test = query_result.sample(n=n_test, random_state=seed)
        random_test['target'] = target
        final_test = final_test.append(random_test)
        query_result = query_result.drop(random_test.index)
    
    if n_val > 0:
        random_val = query_result.sample(n=n_val, random_state=seed)
        random_val['target'] = target
        final_val = final_val.append(random_val)
        query_result = query_result.drop(random_val.index)
    
    if n_train > 0:
        random_train = query_result.sample(n=n_train, random_state=seed)
        random_train['target'] = target
        final_train = final_train.append(random_train)
    
    return final_train, final_val, final_test

def create_train_val_dataset(females_benign_file, females_malignant_file, males_benign_file, males_malignant_file, distribution_file, test_file, output_folder, random_seed):
    final_train = pd.DataFrame()
    final_val = pd.DataFrame()
    final_test = pd.DataFrame()

    optimal_sol = pd.read_csv(distribution_file)
    test_sol = pd.read_csv(test_file)
    df_optimal_sol = pd.DataFrame(optimal_sol, columns=['M','B','MM','MF','BM','BF','MMA','MMB','MFA','MFB','BMA','BMB','BFA','BFB'])
    df_test_sol = pd.DataFrame(test_sol, columns=['M','B','MM','MF','BM','BF','MMA','MMB','MFA','MFB','BMA','BMB','BFA','BFB'])
    train_fraction_calibrated = 0.8
    selected_columns=['isic_id', 'sex', 'age_approx']

    # 1. benign females

    # 1.1 0-59
    mf = pd.read_csv(females_benign_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'female') & (df['age_approx'] < 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.BFA[0]))
    n_val = df_optimal_sol.BFA[0]-n_train
    n_test = df_test_sol.BFA[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, BENIGN, random_seed)

    # 1.2 >= 60
    mf = pd.read_csv(females_benign_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'female') & (df['age_approx'] >= 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.BFB[0]))
    n_val = df_optimal_sol.BFB[0]-n_train
    n_test = df_test_sol.BFB[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, BENIGN, random_seed)

    # 2. malignant females

    # 2.1 0-59
    mf = pd.read_csv(females_malignant_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'female') & (df['age_approx'] < 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.MFA[0]))
    n_val = df_optimal_sol.MFA[0]-n_train
    n_test = df_test_sol.MFA[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, MALIGNANT, random_seed)

    # 2.2 >= 60
    mf = pd.read_csv(females_malignant_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'female') & (df['age_approx'] >= 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.MFB[0]))
    n_val = df_optimal_sol.MFB[0]-n_train
    n_test = df_test_sol.MFB[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, MALIGNANT, random_seed)

    # 3. benign males

    # 3.1 0-59
    mf = pd.read_csv(males_benign_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'male') & (df['age_approx'] < 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.BMA[0]))
    n_val = df_optimal_sol.BMA[0]-n_train
    n_test = df_test_sol.BMA[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, BENIGN, random_seed)

    # 3.2 >= 60
    mf = pd.read_csv(males_benign_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'male') & (df['age_approx'] >= 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.BMB[0]))
    n_val = df_optimal_sol.BMB[0]-n_train
    n_test = df_test_sol.BMB[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, BENIGN, random_seed)

    # 4. malignant males

    # 4.1 0-59
    mf = pd.read_csv(males_malignant_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'male') & (df['age_approx'] < 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.MMA[0]))
    n_val = df_optimal_sol.MMA[0]-n_train
    n_test = df_test_sol.MMA[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, MALIGNANT, random_seed)

    # 4.2 >= 60
    mf = pd.read_csv(males_malignant_file)
    df = pd.DataFrame(mf, columns=selected_columns)
    df = df.dropna(subset=['age_approx'])
    query_result = df[(df['sex'] == 'male') & (df['age_approx'] >= 60)]
    n_train = int(round(train_fraction_calibrated * df_optimal_sol.MMB[0]))
    n_val = df_optimal_sol.MMB[0]-n_train
    n_test = test_sol.MMB[0]
    final_train, final_val, final_test = random_select_train_val_test_instances(final_train, final_val, final_test, query_result, n_train, n_val, n_test, MALIGNANT, random_seed)

    final_train = final_train.reset_index(drop=True)
    final_val = final_val.reset_index(drop=True)
    final_test = final_test.reset_index(drop=True)



    # shuffle content of metadata file and save
    final_train = final_train.sample(frac=1)
    final_train.reset_index(drop=True, inplace=True)

    final_val = final_val.sample(frac=1)
    final_val.reset_index(drop=True, inplace=True)

    final_test = final_test.sample(frac=1)
    final_test.reset_index(drop=True, inplace=True)

    prefix = os.path.basename(distribution_file)
    prefix = os.path.splitext(prefix)[0]

    # write test file only once
    if prefix == "T_s50_a50":
        final_test.to_csv(output_folder + prefix + '_test_' + str(random_seed) + '.csv', index=False)
    else:
        final_train.to_csv(output_folder + prefix + '_train_' + str(random_seed) + '.csv', index=False)
        final_val.to_csv(output_folder + prefix + '_val_' + str(random_seed) + '.csv', index=False)

working_dir = os.getcwd()
females_benign_file = working_dir + '/2_pipeline/9_remove_multip/store/benign_female_all_ages.csv'
females_malignant_file = working_dir + '/2_pipeline/9_remove_multip/store/malignant_female_all_ages.csv'
males_benign_file = working_dir + '//2_pipeline/9_remove_multip/store/benign_male_all_ages.csv'
males_malignant_file = working_dir + '/2_pipeline/9_remove_multip/store/malignant_male_all_ages.csv'
output_folder = working_dir + '/2_pipeline/6_create_statistically_representative_dataset/store/' 
test_file = working_dir + '/2_pipeline/matlab/store/T_s50_a50.csv'
seeds = np.array([1970, 1972, 2008, 2019, 2024])
folder_path = working_dir + '/2_pipeline/matlab/store'
files = os.listdir(folder_path)
for file in files:
    distribution_file = folder_path + '/' + file
    for random_seed in seeds:
        create_train_val_dataset(females_benign_file, females_malignant_file, males_benign_file, males_malignant_file, distribution_file, test_file, output_folder, random_seed)
