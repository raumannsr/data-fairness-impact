%% read constraints
folder = '../../2_pipeline/notebooks/store/';
data_table = readtable(fullfile(folder,'compiled_isic_dataset.csv'));

%% Create balanced dataset
sex_malignancy_ratio = 1;
sex_benign_ratio = 1;
age_maligancy_ratio_males = 1;
age_benign_ratio_males = 1;
age_malignancy_ratio_females = 1;
age_benign_ratio_females = 1;
ub = zeros(1,14);

% ISIC based
AVAILABLE_BENIGN_FEMALES_U60 = data_table{7, 2};
AVAILABLE_BENIGN_FEMALES_A60 = data_table{8, 2};
AVAILABLE_BENIGN_MALES_U60 = data_table{7, 4};
AVAILABLE_BENIGN_MALES_A60 = data_table{8, 4};
AVAILABLE_MALIGNANT_FEMALES_U60 = data_table{7, 3};
AVAILABLE_MALIGNANT_FEMALES_A60 = data_table{8, 3};
AVAILABLE_MALIGNANT_MALES_U60 = data_table{7, 5};
AVAILABLE_MALIGNANT_MALES_A60 = data_table{8, 5};
AVAILABLE_MALIGNANT_MALES = AVAILABLE_MALIGNANT_MALES_A60+AVAILABLE_MALIGNANT_MALES_U60;
AVAILABLE_MALIGNANT_FEMALES = AVAILABLE_MALIGNANT_FEMALES_U60+AVAILABLE_MALIGNANT_FEMALES_A60;
AVAILABLE_BENIGN_MALES = AVAILABLE_BENIGN_MALES_U60+AVAILABLE_BENIGN_MALES_A60;
AVAILABLE_BENIGN_FEMALES = AVAILABLE_BENIGN_FEMALES_U60+AVAILABLE_BENIGN_FEMALES_A60;
AVAILABLE_MALIGNANT_RECORDS = AVAILABLE_MALIGNANT_FEMALES_U60+AVAILABLE_MALIGNANT_FEMALES_A60+AVAILABLE_MALIGNANT_MALES_A60+AVAILABLE_MALIGNANT_MALES_U60;


ub(1) = AVAILABLE_MALIGNANT_RECORDS;
ub(2) = ub(1);
ub(3) = AVAILABLE_MALIGNANT_MALES;
ub(4) = AVAILABLE_MALIGNANT_FEMALES;
ub(5) = AVAILABLE_BENIGN_MALES;
ub(6) = AVAILABLE_BENIGN_FEMALES;
ub(7) = AVAILABLE_MALIGNANT_MALES_U60;
ub(8) = AVAILABLE_MALIGNANT_MALES_A60;
ub(9) = AVAILABLE_MALIGNANT_FEMALES_U60;
ub(10) = AVAILABLE_MALIGNANT_FEMALES_A60;
ub(11) = AVAILABLE_BENIGN_MALES_U60;
ub(12) = AVAILABLE_BENIGN_MALES_A60;
ub(13) = AVAILABLE_BENIGN_FEMALES_U60;
ub(14) = AVAILABLE_BENIGN_FEMALES_A60;


balanced_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
test_set = round(0.125*(balanced_dataset));
balanced_dataset = balanced_dataset - test_set;
%% Correct upperbound for holding out test set
ub = ub - test_set;

%% Biased Dataset (100% Males)
sex_malignancy_ratio = 10000/1;
sex_benign_ratio = 10000/1;
age_maligancy_ratio_males = 1;
age_benign_ratio_males = 1;
age_malignancy_ratio_females = 1;
age_benign_ratio_females = 1;
biased_males_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_males_dataset = round(biased_males_dataset);

%% Biased Dataset 25M-75F Dataset
sex_malignancy_ratio = 25/75;
sex_benign_ratio = 25/75;
age_maligancy_ratio_males = 1;
age_benign_ratio_males = 1;
age_malignancy_ratio_females = 1;
age_benign_ratio_females = 1;
biased_25m_75f_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_25m_75f_dataset = round(biased_25m_75f_dataset);

%% Biased Dataset 75M-25F Dataset
sex_malignancy_ratio = 75/25;
sex_benign_ratio = 75/25;
age_maligancy_ratio_males = 1;
age_benign_ratio_males = 1;
age_malignancy_ratio_females = 1;
age_benign_ratio_females = 1;
biased_75m_25f_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_75m_25f_dataset = round(biased_75m_25f_dataset);

%% Biased Dataset (100% Females)
sex_malignancy_ratio = 1/10000;
sex_benign_ratio = 1/10000;
age_maligancy_ratio_males = 1;
age_benign_ratio_males = 1;
age_malignancy_ratio_females = 1;
age_benign_ratio_females = 1;
biased_females_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_females_dataset = round(biased_females_dataset);

%% Biased Dataset (0-59 age group)
sex_malignancy_ratio = 1;
sex_benign_ratio = 1;
age_maligancy_ratio_males = 10000/1;
age_benign_ratio_males = 10000/1;
age_malignancy_ratio_females = 10000/1;
age_benign_ratio_females = 10000/1;
biased_age_u60_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_age_u60_dataset = round(biased_age_u60_dataset);

%% Biased Dataset (>=60 age group)
sex_malignancy_ratio = 1;
sex_benign_ratio = 1;
age_maligancy_ratio_males = 1/10000;
age_benign_ratio_males = 1/10000;
age_malignancy_ratio_females = 1/10000;
age_benign_ratio_females = 1/10000;
biased_age_a60_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_age_a60_dataset = round(biased_age_a60_dataset);

%% Biased Dataset (mixed 25% 0-59)
sex_malignancy_ratio = 1;
sex_benign_ratio = 1;
age_maligancy_ratio_males = 25/75;
age_benign_ratio_males = 25/75;
age_malignancy_ratio_females = 25/75;
age_benign_ratio_females = 25/75;
biased_age_25_75_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_age_25_75_dataset = round(biased_age_25_75_dataset);

%% Biased Dataset (mixed 75% 0-59)
sex_malignancy_ratio = 1;
sex_benign_ratio = 1;
age_maligancy_ratio_males = 75/25;
age_benign_ratio_males = 75/25;
age_malignancy_ratio_females = 75/25;
age_benign_ratio_females = 75/25;
biased_age_75_25_dataset = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, ub);
biased_age_75_25_dataset = round(biased_age_75_25_dataset);


%% Determine minimum malignant instances in datasets
malignant_instances = [balanced_dataset(1), biased_males_dataset(1), biased_females_dataset(1), biased_age_u60_dataset(1), biased_age_a60_dataset(1), biased_75m_25f_dataset(1), biased_75m_25f_dataset(1), biased_age_75_25_dataset(1), biased_age_25_75_dataset(1)];
min_malignant_instances = min(malignant_instances);

%% Calibrate datasets based on minimal malignant instances
balanced_dataset_factor = balanced_dataset(1)/min_malignant_instances;
balanced_dataset_new = round(balanced_dataset/balanced_dataset_factor);

biased_males_dataset_factor = biased_males_dataset(1)/min_malignant_instances;
biased_males_dataset_new = round(biased_males_dataset/biased_males_dataset_factor);

biased_females_dataset_factor = biased_females_dataset(1)/min_malignant_instances;
biased_females_dataset_new = round(biased_females_dataset/biased_females_dataset_factor);

biased_age_u60_dataset_factor = biased_age_u60_dataset(1)/min_malignant_instances;
biased_age_u60_dataset_new = round(biased_age_u60_dataset/biased_age_u60_dataset_factor);

biased_age_a60_dataset_factor = biased_age_a60_dataset(1)/min_malignant_instances;
biased_age_a60_dataset_new = round(biased_age_a60_dataset/biased_age_a60_dataset_factor);

biased_25m_75f_dataset_factor = biased_25m_75f_dataset(1)/min_malignant_instances;
biased_25m_75f_dataset_new = round(biased_25m_75f_dataset/biased_25m_75f_dataset_factor);

biased_75m_25f_dataset_factor = biased_75m_25f_dataset(1)/min_malignant_instances;
biased_75m_25f_dataset_new = round(biased_75m_25f_dataset/biased_75m_25f_dataset_factor);

biased_age_25_75_dataset_factor = biased_age_25_75_dataset(1)/min_malignant_instances;
biased_age_25_75_dataset_new = round(biased_age_25_75_dataset/biased_age_25_75_dataset_factor);

biased_age_75_25_dataset_factor = biased_age_75_25_dataset(1)/min_malignant_instances;
biased_age_75_25_dataset_new = round(biased_age_75_25_dataset/biased_age_75_25_dataset_factor);

%% write results to file
folder = '../../2_pipeline/matlab/out/';

write_dataset_solution(balanced_dataset, folder, 'D_s50_a50.csv');
write_dataset_solution(biased_males_dataset, folder,'D_s0_a50.csv');
write_dataset_solution(biased_females_dataset, folder,'D_s100_a50.csv');
write_dataset_solution(biased_age_u60_dataset, folder,'D_s50_a100.csv');
write_dataset_solution(biased_age_a60_dataset, folder,'D_s50_a0.csv');
write_dataset_solution(biased_25m_75f_dataset, folder,'D_s75_a50.csv');
write_dataset_solution(biased_75m_25f_dataset, folder,'D_s25_a50.csv');
write_dataset_solution(biased_age_75_25_dataset, folder, 'D_s50_a75.csv');
write_dataset_solution(biased_age_25_75_dataset, folder, 'D_s50_a25.csv');


folder = '../../2_pipeline/matlab/store/';

write_dataset_solution(balanced_dataset_new, folder, 'D_s50_a50.csv');
write_dataset_solution(biased_males_dataset_new, folder,'D_s0_a50.csv');
write_dataset_solution(biased_females_dataset_new, folder,'D_s100_a50.csv');
write_dataset_solution(biased_age_u60_dataset_new, folder,'D_s50_a100.csv');
write_dataset_solution(biased_age_a60_dataset_new, folder,'D_s50_a0.csv');
write_dataset_solution(biased_25m_75f_dataset_new, folder,'D_s75_a50.csv');
write_dataset_solution(biased_75m_25f_dataset_new, folder,'D_s25_a50.csv');
write_dataset_solution(biased_age_75_25_dataset_new, folder, 'D_s50_a75.csv');
write_dataset_solution(biased_age_25_75_dataset_new, folder, 'D_s50_a25.csv');
write_dataset_solution(test_set, folder,'T_s50_a50.csv');