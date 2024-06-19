export HINTS_TRAIN_VAL_TEST_PATH="../../2_pipeline/6_create_statistically_representative_dataset/store"
export HINTS_NUM_EPOCHS=2
export HINTS_STEPS_PER_EPOCH=10
export HINTS_BATCH_SIZE=20
export HINTS_INPUT_SHAPE="384,384,3"
export HINTS_VERBOSE="True"
export HINTS_VAL_STEPS=50
export HINTS_PRED_STEPS=60
export HINTS_EXPERIMENT_PATH="../../2_pipeline/experiments/out"
export HINTS_EXPERIMENT_ID="E01M"
export HINTS_SAVE_MODEL="True"
export HINTS_LEARNING_RATE=2e-5
export HINTS_MOMENTUM=0

seed=1970
export HINTS_IMAGE_PATH="/images384_384/$seed"
export HINTS_PREDICTION_FILE="mtl_s50_a50_predictions_$seed.csv"
export HINTS_TRAIN_FILE="D_s50_a50_train_$seed.csv"
export HINTS_VALIDATION_FILE="D_s50_a50_val_$seed.csv"
export HINTS_TEST_FILE="T_s50_a50_test_$seed.csv"
export HINTS_MODEL_WEIGHTS_FILE="mtl_s50_a50_weights_$seed"
export HINTS_MODEL_HISTORY_FILE="mtl_s50_a50_acc_and_loss_$seed.csv"
export HINTS_MODEL_PERFORMANCE_FILE="mtl_s50_a50_performance_$seed.csv"
export HINTS_SEED=$seed

python3 ../1_mtl_strengthen.py