import numpy as np
import pandas as pd
import os
import re
import sys
from sklearn.utils import class_weight
from sklearn.model_selection import train_test_split
from environment_variables import EnvVarsSingleton
from hints_helpers import LoggerSingleton
from hints_helpers import set_working_dir
import definitions

NAME = '4_prepare_train_val_test_data'
PROJECT = 'HINTS'

def get_train_val_test(class_label, class_id, demographics_label, demographics_id):
    env_vars = EnvVarsSingleton.instance()

    LoggerSingleton.instance().log('1/2 train_test_split: in test set and training and validation data')
    X_train, X_test, y_train, y_test = train_test_split(
        class_id,
        class_label,
        test_size=0.2,
        random_state=env_vars.get_seed(),
        shuffle=True,
        stratify=class_label)
    LoggerSingleton.instance().log('2/2 train_test_split: in training and validation data')
    X_train, X_validate, y_train, y_validate = train_test_split(
        X_train,
        y_train,
        test_size=0.2,
        random_state=env_vars.get_seed(),
        shuffle=True,
        stratify=y_train)

    LoggerSingleton.instance().log('1/3 collect training data for demographics')
    LoggerSingleton.instance().log('Random training demographics = ' + str(env_vars.get_random_demographics()))
    LoggerSingleton.instance().log('All training demographics one = ' + str(env_vars.get_all_one()))
    if env_vars.get_random_demographics():
        demographics_train = 1.0 * np.random.randint(2, size=len(X_train))
    else:
        if env_vars.get_all_one():
            demographics_train = 1.0 * np.ones(len(X_train))
        else:
            demographics_train = np.zeros(len(X_train))
            for i in range(len(X_train)):
                for j in range(len(demographics_id)):
                    if demographics_id.iloc[j] == X_train.iloc[i]:
                        demographics_train[i] = demographics_label.iloc[j]
                        break

    LoggerSingleton.instance().log('2/3 collect validation data for demographics')
    LoggerSingleton.instance().log('Random validation demographics = ' + str(env_vars.get_random_demographics()))
    LoggerSingleton.instance().log('All validation demographics one = ' + str(env_vars.get_all_one()))
    if env_vars.get_random_demographics():
        demographics_validate = 1.0 * np.random.randint(2, size=len(X_validate))
    else:
        if env_vars.get_all_one():
            demographics_validate = 1.0 * np.ones(len(X_validate))
        else:
            demographics_validate = np.zeros(len(X_validate))
            for i in range(len(X_validate)):
                for j in range(len(demographics_id)):
                    if demographics_id.iloc[j] == X_validate.iloc[i]:
                        demographics_validate[i] = demographics_label.iloc[j]
                        break

    LoggerSingleton.instance().log('3/3 collect test data for demographics')

    demographics_test = np.zeros(len(X_test))
    for i in range(len(X_test)):
        for j in range(len(demographics_id)):
            if demographics_id.iloc[j] == X_test.iloc[i]:
                demographics_test[i] = demographics_label.iloc[j]
                break

    class_weights = class_weight.compute_class_weight('balanced', np.unique(y_train), y_train)
    class_weights = {i: class_weights[i] for i in range(2)}

    # Depending on the desired fraction of samples deployed for training and validation.
    # Example: fraction = 0.5, means that only half of the available training and validation samples are used.
    samples_to_drop = int((1 - env_vars.get_fraction()) * X_train.count())
    X_train.drop(X_train.tail(samples_to_drop).index, inplace=True)
    y_train.drop(y_train.tail(samples_to_drop).index, inplace=True)

    samples_to_drop = int((1 - env_vars.get_fraction()) * X_validate.count())
    X_validate.drop(X_validate.tail(samples_to_drop).index, inplace=True)
    y_validate.drop(y_validate.tail(samples_to_drop).index, inplace=True)

    train = definitions.Dataset(X_train, y_train)
    validate = definitions.Dataset(X_validate, y_validate)

    test = definitions.Dataset(X_test, y_test)
    train_dmg = definitions.Dataset(X_train, demographics_train)
    validate_dmg = definitions.Dataset(X_validate, demographics_validate)
    test_dmg = definitions.Dataset(X_test, demographics_test)

    LoggerSingleton.instance().log('in train set      = \n' + str(y_train.value_counts()))
    LoggerSingleton.instance().log('in validation set = \n' + str(y_validate.value_counts()))
    LoggerSingleton.instance().log('in test set       = \n' + str(y_test.value_counts()))

    return train, validate, test, train_dmg, validate_dmg, test_dmg, class_weights


def get_output_filename(name):
    pipeline = os.path.join(EnvVarsSingleton.instance().get_pipeline_folder(), NAME)
    filename = os.path.join(pipeline, 'out', EnvVarsSingleton.instance().get_experiments_folder(), str(EnvVarsSingleton.instance().get_seed()), name)
    return filename

env_vars = EnvVarsSingleton.instance()
if len(sys.argv) == 3:
    env_vars.set_fraction(float(sys.argv[1]))
    env_vars.set_seed(int(sys.argv[2]))

metadata = pd.read_csv(EnvVarsSingleton.instance().get_meta_data_file())
ground_truth = pd.read_csv(EnvVarsSingleton.instance().get_ground_truth_file())
df1 = pd.merge(metadata, ground_truth)

# MEL:NV = 1:1
df2 = df1.query('MEL == 1')
df3 = df1.query('NV == 1').sample(n=len(df2), random_state=env_vars.get_seed())
lesions = pd.concat([df2, df3])
lesions.loc[lesions['MEL'] == 1, 'diagnosis_category'] = 1
lesions.loc[lesions['NV'] == 1, 'diagnosis_category'] = 0
lesions['sex_category'] = 0
lesions.loc[lesions['sex'] == 'female', 'sex_category'] = 1
lesions["age_category"] = pd.cut(lesions['age_approx'], bins=[0., 54, 86], labels=[0, 1])
lesions.drop(lesions[lesions['age_approx'] == 0].index, inplace=True)

train_set, validate_set, test_set, train_dmg_set, validate_dmg_set, test_dmg_set, class_wghts = \
    get_train_val_test(lesions['diagnosis_category'], lesions['image'], lesions['age_category'], lesions['image'])

set_working_dir()
train_set.to_csv(get_output_filename('train_set.csv'))
validate_set.to_csv(get_output_filename('validate_set.csv'))
test_set.to_csv(get_output_filename('test_set.csv'))
train_dmg_set.to_csv(get_output_filename('train_dmg_set.csv'))
validate_dmg_set.to_csv(get_output_filename('validate_dmg_set.csv'))
test_dmg_set.to_csv(get_output_filename('test_dmg_set.csv'))
