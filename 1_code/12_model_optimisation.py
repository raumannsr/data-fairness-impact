#  Optimise single-task ResNet50 model using a balanced train and validation dataset (s=50,a=50) 
#  and evaluate with a balanced test set.

# Parameters for tuning: learning rate, batch size, ?
# Use a grid search technique

# Evaluation metric AUC is based on overall model performance (not per subgroup)
import sys
from environment_variables import EnvVarsSingleton
from hints_helpers import FileSystemUtils
from stl_model import STLModel
import numpy as np
from keras.callbacks import EarlyStopping

NAME = '12_model_optimisation'
PROJECT = 'HINTS'

HINTS_INPUT_WIDTH = 384
HINTS_INPUT_HEIGHT = 384
HINTS_INPUT_DEPTH = 3
HINTS_CONV_LAYER_FROZEN = False
HINTS_VERBOSE = True
HINTS_BATCH_SIZE=20
HINTS_STEPS_PER_EPOCH=100
HINTS_VALIDATION_STEPS=50
HINTS_PREDICTIONS_STEPS=25

#HINTS_IMAGE_PATH= '/home/ralf/DATA/ISIC-BASED/images384_384/1970'
#HINTS_METADATA_FILE= '/home/ralf/DATA/ISIC-BASED/images384_384/1970/metadata/D_s50_a50'
HINTS_PIPELINE_FOLDER='/home/ralf/git_repositories/multi-task-strengthen-weaken/2_pipeline/12_model_optimisation/out'

env_vars = EnvVarsSingleton.instance()
env_vars.set_input_shape(HINTS_INPUT_WIDTH, HINTS_INPUT_HEIGHT, HINTS_INPUT_DEPTH)
env_vars.set_con_layer_frozen(HINTS_CONV_LAYER_FROZEN)
env_vars.set_verbose(HINTS_VERBOSE)
env_vars.set_steps_per_epoch(HINTS_STEPS_PER_EPOCH)
env_vars.set_validation_steps(HINTS_VALIDATION_STEPS)
env_vars.set_batch_size(HINTS_BATCH_SIZE)
env_vars.set_prediction_steps(HINTS_PREDICTIONS_STEPS)
env_vars.set_pipeline_folder(HINTS_PIPELINE_FOLDER)

early_stopping = EarlyStopping(monitor='val_acc', patience=10, verbose=1)

start_lr = 1e-4
end_lr = 2e-5
lrs = np.logspace(np.log10(start_lr), np.log10(end_lr), 3)

# original:
# seeds = [1970, 1972, 2008]
# momenta = [0.0, 0.5, 0.9]

# temporary:
seeds = [2008]
momenta = [0.0]
lrs = [2e-5]

env_vars = EnvVarsSingleton.instance()

dataset_file = 'D_s100_a50'
test_file = 'T_s50_a50'

for seed in seeds:
    train_file = dataset_file +'_train_' + str(seed) + '.csv'
    validation_file = dataset_file +'_val_' + str(seed) + '.csv'
    test_file = test_file +'_test_' + str(seed) + '.csv'
    mt_cnt = 0
    for momentum in momenta:
        env_vars.set_epochs(40)
        lr_cnt = 0
        for lr in lrs:
            HINTS_IMAGE_PATH= '/home/ralf/DATA/ISIC-BASED/images384_384/' + str(seed)
            HINTS_METADATA_FILE= '/home/ralf/DATA/ISIC-BASED/images384_384/' + str(seed) + '/metadata/'
            env_vars.set_seed(seed)
            env_vars.set_image_path(HINTS_IMAGE_PATH)
            env_vars.set_meta_data_file(HINTS_METADATA_FILE)
            model = STLModel()
            model.read_train_val_test_data(train_file, validation_file, test_file)
            model.build_model(lr, momentum)
            model.fit_model(early_stopping)
            env_vars.set_meta_data_file('mt' + str(mt_cnt) + '_lr' + str(lr_cnt) + '_D_s100_a50')
            model.predict_model()
            model.report_metrics()
            lr_cnt += 1
        mt_cnt += 1