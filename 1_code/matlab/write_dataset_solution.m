function [] = write_dataset_solution(result, folder, filename)
data_row = repmat(result, 1, 1);
dataTable = array2table(data_row, 'VariableNames', { 'M', 'B', 'MM', 'MF', 'BM', 'BF', 'MMA', 'MMB', 'MFA', 'MFB', 'BMA', 'BMB', 'BFA', 'BFB'});
f = fullfile(folder,filename);
writetable(dataTable, f);