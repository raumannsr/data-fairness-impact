export HINTS_NUM_EPOCHS=40
export HINTS_STEPS_PER_EPOCH=100
export HINTS_BATCH_SIZE=20
export HINTS_INPUT_SHAPE="384,384,3"
export HINTS_VERBOSE="False"
export HINTS_VAL_STEPS=50
export HINTS_PRED_STEPS=60
export HINTS_EXPERIMENT_PATH="/home/user_name/git_repositories/multi-task-BR-net/2_pipeline/experiments"
export HINTS_EXPERIMENT_ID="E05BR"
export HINTS_SAVE_MODEL="True"
export HINTS_MOMENTUM=0
export HINTS_LAMDA=5

seeds=(1970 1972 2008 2019 2024)
for seed in "${seeds[@]}"; do
  echo "Processing seed: $seed"
  export HINTS_TRAIN_VAL_TEST_PATH="/home/user_name/DATA/ISIC-BASED/images384_384/$seed/metadata"
  export HINTS_IMAGE_PATH="/home/user_name/DATA/ISIC-BASED/images384_384/$seed"
  export HINTS_PREDICTION_FILE="br_s100_a50_predictions_$seed.csv"
  export HINTS_TRAIN_FILE="D_s100_a50_train_$seed.csv"
  export HINTS_VALIDATION_FILE="D_s100_a50_val_$seed.csv"
  export HINTS_TEST_FILE="T_s50_a50_test_$seed.csv"
  export HINTS_MODEL_WEIGHTS_FILE="br_s100_a50_weights_$seed"
  export HINTS_MODEL_HISTORY_FILE="br_s100_a50_acc_and_loss_$seed.csv"
  export HINTS_MODEL_PERFORMANCE_FILE="br_s100_a50_performance_$seed.csv"
  export HINTS_SEED=$seed
  python3 ../br-net.py
done