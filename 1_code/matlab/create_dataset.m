function [results] = create_dataset(sex_malignancy_ratio, sex_benign_ratio, age_maligancy_ratio_males, age_benign_ratio_males, age_malignancy_ratio_females, age_benign_ratio_females, bounds)
    results = zeros(1,14);
    lb = zeros(14,1);
    ub = zeros(1,14);
    A = zeros(0,14); 
    b= zeros(0);
    f = zeros(14,1);

    RATIO_MALES_AND_FEMALES = sex_benign_ratio;
    RATIO_MALES = age_benign_ratio_males;
    RATIO_FEMALES = age_benign_ratio_females;
    
    RATIO_MALIGNANT_MALES_AND_FEMALES = sex_malignancy_ratio;
    RATIO_MALIGNANT_MALES = age_maligancy_ratio_males;
    RATIO_MALIGNANT_FEMALES = age_malignancy_ratio_females;

    % x1 = M    x7 = MMA    x13 = BFA
    % x2 = B    x8 = MMB    x14 = BFB
    % x3 = MM   x9 = MFA
    % x4 = MF   x10 = MFB
    % x5 = BM   x11 = BMA
    % x6 = BF   x12 = BMB
    for i = 1:14
        ub(i) = bounds(i);
    end
    
    Aeq=zeros(13,14); % 13 equations in 14 variables
    beq=zeros(13,1); % Aeq X = beq
    
    % M and B equal: M-B=0 -> x1-x2=0
    Aeq(1, [1,2]) = [1,-1];
    
    % ratio between MM and MF (= RATIO_MALIGNANT_MALES_AND_FEMALES): R.MF - MM = 0 -> Rx4 - x3 = 0
    Aeq(2, [4,3]) = [RATIO_MALIGNANT_MALES_AND_FEMALES, -1];
    
    %% Malignant
    
    % ratio between MM0059 and MM60 (= RATIO_MALIGNANT_MALES): 
    % R.MM60 - MM059 = 0 -> Rx8 - x7 = 0
    Aeq(3, [8,7]) = [RATIO_MALIGNANT_MALES,-1];
    
    % ratio between MF0059 and MF60 (= RATIO_MALIGNANT_FEMALES):
    Aeq(4, [10,9]) = [RATIO_MALIGNANT_FEMALES,-1];
    
    % M = MM + MF
    Aeq(5, [1,3,4]) = [1,-1,-1];
    
    % MM = MM059 + MM60
    Aeq(6, [3,7,8]) = [1,-1,-1];
    
    % MF = MF0059 + MF60
    Aeq(7, [4,9,10]) = [1,-1,-1];
    
    %% Benign
    
    % ratio between BM0059 and BM60: 
    Aeq(8, [12,11]) = [RATIO_MALES,-1];
    
    % ratio between BF0059 and BF60:
    Aeq(9, [14,13]) = [RATIO_FEMALES,-1];
    
    % B = BM + BF
    Aeq(10, [2,5,6]) = [1,-1,-1];
    
    % BF = BF059 + BF60
    Aeq(11, [6,13,14]) = [1,-1,-1];
    
    % BM = BM059 + BM60
    Aeq(12, [5,11,12]) = [1,-1,-1];
    
    % ratio between BM and BF
    Aeq(13, [6,5]) = [RATIO_MALES_AND_FEMALES, -1];
    
    %% set objective function vector, cost = -M
    f(1)=-1;
    
    %% evaluate model
    [x, ~] = linprog(f,A,b,Aeq,beq,lb,ub);
    
    for i = 1:14
        results(i) = x(i);
    end
end
