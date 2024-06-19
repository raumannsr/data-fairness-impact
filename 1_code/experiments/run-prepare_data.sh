export HINTS_BASE_FOLDER='/home/user_name/git_repositories/multi-task-strengthen-weaken'
export HINTS_PIPELINE_FOLDER='../../2_pipeline/10_remove_invalid_age'

rem STEP 1: REMOVE INVALID AGE RECORDS
python3 ../10_remove_invalid_age.py '/0_data/ISIC-BASED/benign_female_all_ages.csv' 'benign_female_all_ages_invalid.csv'
python3 ../10_remove_invalid_age.py '/0_data/ISIC-BASED/benign_male_all_ages.csv' 'benign_male_all_ages_invalid.csv'
python3 ../10_remove_invalid_age.py '/0_data/ISIC-BASED/malignant_female_all_ages.csv' 'malignant_female_all_ages_invalid.csv'
python3 ../10_remove_invalid_age.py '/0_data/ISIC-BASED/malignant_male_all_ages.csv' 'malignant_male_all_ages_invalid.csv'

rem STEP 2.1 FIND DUPLICATES
export HINTS_PIPELINE_FOLDER='/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/7_find_duplicates'
export HINTS_EXPERIMENT_FOLDER=BenignFemaleDermoscopicAllAges
export HINTS_IMAGE_PATH='/home/user_name/DATA/ISIC-BASED/BenignFemaleDermoscopicAllAges'
python3 ../7_find_duplicates.py
export HINTS_EXPERIMENT_FOLDER=BenignMaleDermoscopicAllAges
export HINTS_IMAGE_PATH='/home/user_name/DATA/ISIC-BASED/BenignMaleDermoscopicAllAges'
python3 ../7_find_duplicates.py
export HINTS_EXPERIMENT_FOLDER=MalignantFemaleDermoscopicAllAges
export HINTS_IMAGE_PATH='/home/user_name/DATA/ISIC-BASED/MalignantFemaleDermoscopicAllAges'
python3 ../7_find_duplicates.py
export HINTS_EXPERIMENT_FOLDER=MalignantMaleDermoscopicAllAges
export HINTS_IMAGE_PATH='/home/user_name/DATA/ISIC-BASED/MalignantMaleDermoscopicAllAges'
python3 ../7_find_duplicates.py'benign_male_all_ages_invalid.csv'

REM STEP 2.2 REMOVE DUPLICATES
export HINTS_PIPELINE_FOLDER=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/8_remove_duplicates
export HINTS_EXPERIMENT_FOLDER=BenignFemaleDermoscopicAllAges
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/10_remove_invalid_age/store/benign_female_all_ages.csv
python3 ../8_remove_duplicates.py 'benign_female_all_ages.csv'

export HINTS_EXPERIMENT_FOLDER=BenignMaleDermoscopicAllAges
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/10_remove_invalid_age/store/benign_male_all_ages.csv
python3 ../8_remove_duplicates.py 'benign_male_all_ages.csv'

export HINTS_EXPERIMENT_FOLDER=MalignantFemaleDermoscopicAllAges
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/10_remove_invalid_age/store/malignant_female_all_ages.csv
python3 ../8_remove_duplicates.py 'malignant_female_all_ages.csv'

export HINTS_EXPERIMENT_FOLDER=MalignantMaleDermoscopicAllAges
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/10_remove_invalid_age/store/malignant_male_all_ages.csv
python3 ../8_remove_duplicates.py 'malignant_male_all_ages.csv'

REM STEP 3 REMOVE MULTIPLETS
export HINTS_PIPELINE_FOLDER='/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/9_remove_multip'
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/8_remove_duplicates/store/benign_female_all_ages.csv
python3 ../9_remove_multip.py benign_female_all_ages_multiplets.csv

export HINTS_PIPELINE_FOLDER='/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/9_remove_multip'
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/8_remove_duplicates/store/benign_male_all_ages.csv
python3 ../9_remove_multip.py benign_male_all_ages_multiplets.csv

export HINTS_PIPELINE_FOLDER='/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/9_remove_multip'
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/8_remove_duplicates/store/malignant_female_all_ages.csv
python3 ../9_remove_multip.py malignant_female_all_ages_multiplets.csv

export HINTS_PIPELINE_FOLDER='/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/9_remove_multip'
export HINTS_METADATA_FILE=/home/user_name/git_repositories/multi-task-strengthen-weaken/2_pipeline/8_remove_duplicates/store/malignant_male_all_ages.csv
python3 ../9_remove_multip.py malignant_male_all_ages_multiplets.csv