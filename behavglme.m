function [glme_result] = behavglme(s,run)
%% fits glme to behavioural data




%% glme 1. formula = 'choice ~ -1 + V '
if run(1) == 1
    
    disp('running glme1...')
    
    reg = [];V = [];TU = [];RU = [];B = [];
    pickregs = {};
    pickregs = {'V'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
        RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
        B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
        tbl = table(choice,V,RU,B,TU);
        formula = 'choice ~ -1 + V ';
         %b. fit logistic glme1:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
        
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{1}.regnames              = pickregs;
        glme_result{1}.glme(isub,:)          = w;
        glme_result{1}.modelcriterion(isub,:)= modelcriterion_double;
    end
end
    


%%glme 2. formula = 'choice ~ -1 + V + TU '
if run(2) == 1
    
   disp('running glme2...')
    
    reg = [];V = [];TU = [];RU = [];B = [];
    pickregs = {};
    pickregs = {'V','TU'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
        RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
        B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
        tbl = table(choice,V,RU,B,TU);
        formula = 'choice ~ -1 + V + TU';
         %b. fit logistic glme2:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
       
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{2}.regnames              = pickregs;
        glme_result{2}.glme(isub,:)          = w;
        glme_result{2}.modelcriterion(isub,:)= modelcriterion_double;
    end
end

%%glme3. formula = 'choice ~ -1 + V + RU '
if run(3) == 1
    
   disp('running glme3...')
    
    reg = [];V = [];TU = [];RU = [];B = [];
    pickregs = {};
    pickregs = {'V','RU'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
        RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
        B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
        tbl = table(choice,V,RU,B,TU);
        formula = 'choice ~ -1 + V + RU';
         %b. fit logistic glme2:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
      
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{3}.regnames              = pickregs;
        glme_result{3}.glme(isub,:)          = w;
        glme_result{3}.modelcriterion(isub,:)= modelcriterion_double;
    end
end

%%glme4. formula = 'choice ~ -1 + V + TU + RU '
if run(4) == 1
    
   disp('running glme4...')
    
    reg = [];V = [];TU = [];RU = [];B = [];
    pickregs = {};
    pickregs = {'V','RU','TU'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
        RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
        B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
        tbl = table(choice,V,RU,B,TU);
        formula = 'choice ~ -1 + V + TU + RU';
         %b. fit logistic glme3:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
      
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{4}.regnames              = pickregs;
        glme_result{4}.glme(isub,:)          = w;
        glme_result{4}.modelcriterion(isub,:)= modelcriterion_double;
    end
end


%%glme5. formula = 'choice ~ -1 + V + TU + RU + B '
if run(5) == 1
    
   disp('running glme5...')
    
    reg = [];V = [];TU = [];RU = [];B = [];
    pickregs = {};
    pickregs = {'V','RU','B','TU'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
        RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
        B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
        tbl = table(choice,V,RU,B,TU);
        formula = 'choice ~ -1 + V + TU + RU + B';
         %b. fit logistic glme4:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
       
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{5}.regnames              = pickregs;
        glme_result{5}.glme(isub,:)          = w;
        glme_result{5}.modelcriterion(isub,:)= modelcriterion_double;
    end
end

%%glme6. formula = 'choice ~ -1 + V + TU + RU + B + interaction '
if run(6) == 1
    
   disp('running glme6...')
    
    reg = [];V = [];TU = [];RU = [];B = [];acc_B = [];unc_B = [];TU_B = [];
    pickregs = {};
    pickregs = {'V','RU','B','TU','acc_B','unc_B','TU_B'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
        RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
        B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
        acc_B = get_from_mat(s.sub{isub}.pmat, 'diff_accxblocktime'); 
        unc_B = get_from_mat(s.sub{isub}.pmat, 'diff_uncxblocktime'); 
        TU_B = get_from_mat(s.sub{isub}.pmat, 'tol_uncxblocktime'); 
        tbl = table(choice,V,RU,B,acc_B,unc_B);
        formula = 'choice ~ -1 + V + RU + B + acc_B + unc_B';
         %b. fit logistic glme4:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
       
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{6}.regnames              = pickregs;
        glme_result{6}.glme(isub,:)          = w;
        glme_result{6}.modelcriterion(isub,:)= modelcriterion_double;
    end
end


%%glme7. formula = 'choice ~ -1 + V + TU + RU + B + interaction_nonorm '
if run(6) == 1
    
   disp('running glme7...')
    
    reg = [];V = [];TU = [];RU = [];B = [];acc_B = [];unc_B = [];TU_B = [];
    pickregs = {};
    pickregs = {'V','RU','B','TU','acc_B','unc_B','TU_B'};
    for isub = 1:length(s.ID)
        % a. regressors:
        unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
        unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
        TU = sqrt(unc_left.^2 + unc_right.^2);
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});     
        V = get_from_mat(s.sub{isub}.pmat, 'diff_acc'); 
        RU = get_from_mat(s.sub{isub}.pmat, 'diff_unc'); 
        B = get_from_mat(s.sub{isub}.pmat, 'blocktime'); 
        acc_B = get_from_mat(s.sub{isub}.pmat, 'diff_accxb_nonorm'); 
        unc_B = get_from_mat(s.sub{isub}.pmat, 'diff_uncxb_nonorm'); 
        TU_B = get_from_mat(s.sub{isub}.pmat, 'tol_uncxb_nonorm'); 
        tbl = table(choice,V,RU,B,acc_B,unc_B);
        formula = 'choice ~ -1 + V + RU + B + acc_B + unc_B';
         %b. fit logistic glme4:
       
        glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
       
        w = fixedEffects(glme);
        modelcriterion = glme.ModelCriterion;
        modelcriterion_double = double(modelcriterion);
        % c. save    
        glme_result{7}.regnames              = pickregs;
        glme_result{7}.glme(isub,:)          = w;
        glme_result{7}.modelcriterion(isub,:)= modelcriterion_double;
    end
end
end