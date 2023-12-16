function [allval] = behavGLM(s,run)
%% fits GLM to behavioural data

% output:   all behavioural figures in maintext of Trudel 2020, NatureHumanBehav
%           1 = across all trials   (decision phase)
%           2 = block halves        (decision phase)
%           3 = time horizon        (decision phase)
%           4 = confidence judgment (confidence phase)



%% GLM 1. Across all trials
if run(1) == 1
    
    disp('running GLM1...')
    
    reg = [];
    pickregs = {};
    pickregs = {'diff_acc','diff_unc', 'blocktime', 'diff_uncxblocktime', 'diff_accxblocktime'};
    for isub = 1:length(s.ID)
        % a. regressors:
        reg    = normalise(get_from_mat(s.sub{isub}.pmat, pickregs)); % regressos are normalised across all trials
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});
        chounch_acc = get_from_mat(s.sub{isub}.pmat, {'chounch_acc'});
        chounch_unc = get_from_mat(s.sub{isub}.pmat, {'chounch_unc'});
        CI          = get_from_mat(s.sub{isub}.pmat, {'cisize'});
        mci         = mean(CI);
        tol_unc     = get_from_mat(s.sub{isub}.pmat, {'tol_unc'});
        mt_unc      = mean(tol_unc);
        payoff      = get_from_mat(s.sub{isub}.pmat, {'payoff'});
        s_payoff    = sum(payoff);
        angle_error = get_from_mat(s.sub{isub}.pmat, {'angle_error'});
        mean_angle  = mean(angle_error);
        outcome = get_from_mat(s.sub{isub}.pmat, {'outcome'});
        mean_outcome  = mean(outcome);
        repetition = get_from_mat(s.sub{isub}.pmat, {'repetition'});
        s_repetition = sum(repetition);
        acc_type = get_from_mat(s.sub{isub}.pmat, {'acc_type'});
        acc_type = sum(acc_type);
        
        precent_unc = get_from_mat(s.sub{isub}.pmat, {'precent_unc'});
        expected_value_type = get_from_mat(s.sub{isub}.pmat, {'expected_value_type'}); 
        EV  = zeros(180,6);
        for i = 1:180
                if      expected_value_type(i) == 1
                        EV(i,1) = precent_unc(i);
                elseif  expected_value_type(i) == 2
                        EV(i,2) = precent_unc(i);
                elseif  expected_value_type(i) == 3
                        EV(i,3) = precent_unc(i);  
                elseif  expected_value_type(i) == 4
                        EV(i,4) = precent_unc(i);  
                elseif  expected_value_type(i) == 5
                        EV(i,5) = precent_unc(i);        
                else
                        EV(i,6) = precent_unc(i);
            
                end
        
        end 
           
            EV1 = mean(nonzeros(EV(:,1)));
            EV2 = mean(nonzeros(EV(:,2)));
            EV3 = mean(nonzeros(EV(:,3)));
            EV4 = mean(nonzeros(EV(:,4)));
            EV5 = mean(nonzeros(EV(:,5)));
            EV6 = mean(nonzeros(EV(:,6)));  
            
        precent_acc = get_from_mat(s.sub{isub}.pmat, {'precent_acc'});
        expected_unc_type = get_from_mat(s.sub{isub}.pmat, {'expected_unc_type'});
        EU  = zeros(180,6);
        for i = 1:180
                if      expected_unc_type(i) == 1
                        EU(i,1) = precent_acc(i);
                elseif  expected_unc_type(i) == 2
                        EU(i,2) = precent_acc(i);
                elseif  expected_unc_type(i) == 3
                        EU(i,3) = precent_acc(i);  
                elseif  expected_unc_type(i) == 4
                        EU(i,4) = precent_acc(i);  
                elseif  expected_unc_type(i) == 5
                        EU(i,5) = precent_acc(i);        
                else
                        EU(i,6) = precent_acc(i);
            
                end
        
        end 
           
            EU1 = mean(nonzeros(EU(:,1)));
            EU2 = mean(nonzeros(EU(:,2)));
            EU3 = mean(nonzeros(EU(:,3)));
            EU4 = mean(nonzeros(EU(:,4)));
            EU5 = mean(nonzeros(EU(:,5)));
            EU6 = mean(nonzeros(EU(:,6)));
        
        exploration_exploitation = zeros(100,3);
            
        for i = 1:180
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0
                        exploration_exploitation(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0
                        exploration_exploitation(i,2) = 1;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        exploration_exploitation(i,3) = 1;
            
                end
        
        end 
            exploitation  = sum(exploration_exploitation(:,1));
            d_exploration = sum(exploration_exploitation(:,2));
            r_exploration = sum(exploration_exploitation(:,3));
            
        performance = zeros(100,1);
            
        for i = 1:180
                if      chounch_acc(i)>0
                        performance(i,1) = 1;
                
                else
                        
                        performance(i,1) = 0;
            
                end
        
        end 
            performance_ratio  = sum(performance(:,1))/180;
            
 
         %b. fit logistic GLM:
        beta  = glmfit(reg,choice, 'binomial','link','logit');
        
        % c. save
        allval{1}.betas(isub,:)         = beta;
        allval{1}.regnames              = pickregs;
        allval{1}.GLMtype               = 'decphase_alltrials';
        allval{1}.exploitation(isub,:)  = exploitation;
        allval{1}.d_exploration(isub,:) = d_exploration;
        allval{1}.r_exploration(isub,:) = r_exploration;
        allval{1}.mean_ci(isub,:)       = mci;
        allval{1}.mean_t_unc(isub,:)    = mt_unc;
        allval{1}.sum_payoff(isub,:)    = s_payoff;
        allval{1}.sum_repetition(isub,:)    = s_repetition;
        allval{1}.acc_type(isub,:)          = acc_type;
        allval{1}.performance_ratio(isub,:)    = performance_ratio;
        allval{1}.mean_angle_error(isub,:)    = mean_angle;
        allval{1}.mean_outcome(isub,:)        = mean_outcome;
        allval{1}.EV1(isub,:)          = EV1;
        allval{1}.EV2(isub,:)          = EV2;
        allval{1}.EV3(isub,:)          = EV3;
        allval{1}.EV4(isub,:)          = EV4;
        allval{1}.EV5(isub,:)          = EV5;
        allval{1}.EV6(isub,:)          = EV6;
        allval{1}.EU1(isub,:)          = EU1;
        allval{1}.EU2(isub,:)          = EU2;
        allval{1}.EU3(isub,:)          = EU3;
        allval{1}.EU4(isub,:)          = EU4;
        allval{1}.EU5(isub,:)          = EU5;
        allval{1}.EU6(isub,:)          = EU6;
        
        
   %%choice prediction
 
       w1 = allval{1}.betas(isub,2);
       w2 = allval{1}.betas(isub,3);
       w3 = allval{1}.betas(isub,4);
       w4 = allval{1}.betas(isub,6);
       w5 = allval{1}.betas(isub,5);

       acc_left = get_from_mat(s.sub{isub}.pmat, {'acc_left'});
       acc_right = get_from_mat(s.sub{isub}.pmat, {'acc_right'});
       unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'});
       unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'});
       blocktime = get_from_mat(s.sub{isub}.pmat, {'blocktime'});
       accxb_left = get_from_mat(s.sub{isub}.pmat, {'accxb_left'});
       accxb_right = get_from_mat(s.sub{isub}.pmat, {'accxb_right'});
       uncxb_left = get_from_mat(s.sub{isub}.pmat, {'uncxb_left'});
       uncxb_right = get_from_mat(s.sub{isub}.pmat, {'uncxb_right'});
       
       
       
       u_left = w1 * acc_left + w2*unc_left + w3*blocktime + w4*accxb_left + w5*uncxb_left;
       u_right = w1 * acc_right + w2*unc_right + w3*blocktime + w4*accxb_right + w5*uncxb_right;
       
       
       choice_prediction = zeros(180,1);
       prediction_ratio = zeros(180,1);
       for i = 1:180
           if u_left(i) > u_right(i)
               choice_prediction(i) = 1;
           else
               choice_prediction(i) = 0;
           end
           
           
           
           if choice_prediction(i) == choice(i)
               prediction_ratio(i) = 1;
           else
               prediction_ratio(i) = 0;
           end
           
       end
       prediction_r = sum(prediction_ratio/180);
       
       allval{1}.choice_prediction(:,isub)          = choice_prediction;
       allval{1}.prediction_r(isub,:)               = prediction_r;
      
       
       
    end
end
    


%% GLM 2. Block halves
if run(2) == 1
    
    disp('running GLM2...')
    
    reg=[];pickregs={};V = [];TU = [];RU = [];B = [];pickregs={'diff_acc','diff_unc'};
    pickglme = {};pickglme = {'V','RU','B','TU'};
    for isub = 1:length(s.ID)
        % a. split trials:
        eval('split_blockhalves')
        for ib = 1:2 %loop through block halves
            % b. regressors:
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg = normalise(reg(idxhalf{ib},:));                            % regressos are normalised within block halves
            
            chounch_acc = get_from_mat(s.sub{isub}.pmat, {'chounch_acc'});
            chounch_acc = chounch_acc(idxhalf{ib},:);
            chounch_unc = get_from_mat(s.sub{isub}.pmat, {'chounch_unc'});
            chounch_unc = chounch_unc(idxhalf{ib},:);
            CI          = get_from_mat(s.sub{isub}.pmat, {'cisize'});
            CI          = CI(idxhalf{ib},:);
            mci         = mean(CI);
            tol_unc     = get_from_mat(s.sub{isub}.pmat, {'tol_unc'});
            tol_unc     = tol_unc(idxhalf{ib},:);
            mt_unc      = mean(tol_unc);
            angle_error = get_from_mat(s.sub{isub}.pmat, {'angle_error'});
            angle_error = angle_error(idxhalf{ib},:);
            mean_angle  = mean(angle_error); 
            precent_unc = get_from_mat(s.sub{isub}.pmat, {'precent_unc'});
            precent_unc = precent_unc(idxhalf{ib},:);
            expected_value_type = get_from_mat(s.sub{isub}.pmat, {'expected_value_type'});
            expected_value_type = expected_value_type(idxhalf{ib},:);
            repetition = get_from_mat(s.sub{isub}.pmat, {'repetition'});
            repetition = repetition(idxhalf{ib},:);
            s_repetition = sum(repetition);
            acc_type = get_from_mat(s.sub{isub}.pmat, {'acc_type'});
            acc_type = acc_type(idxhalf{ib},:);
            acc_type = sum(acc_type);
            
            EV  = zeros(180,6);
            for i = 1:length(idxhalf{ib})
                if      expected_value_type(i) == 1
                        EV(i,1) = precent_unc(i);
                elseif  expected_value_type(i) == 2
                        EV(i,2) = precent_unc(i);
                elseif  expected_value_type(i) == 3
                        EV(i,3) = precent_unc(i);  
                elseif  expected_value_type(i) == 4
                        EV(i,4) = precent_unc(i);  
                elseif  expected_value_type(i) == 5
                        EV(i,5) = precent_unc(i);        
                else
                        EV(i,6) = precent_unc(i);
            
                end
        
            end 
           
            EV1 = mean(nonzeros(EV(:,1)));
            EV2 = mean(nonzeros(EV(:,2)));
            EV3 = mean(nonzeros(EV(:,3)));
            EV4 = mean(nonzeros(EV(:,4)));
            EV5 = mean(nonzeros(EV(:,5)));
            EV6 = mean(nonzeros(EV(:,6)));
            
            precent_acc = get_from_mat(s.sub{isub}.pmat, {'precent_acc'});
            precent_acc = precent_acc(idxhalf{ib},:);
            expected_unc_type = get_from_mat(s.sub{isub}.pmat, {'expected_unc_type'});
            expected_unc_type = expected_unc_type(idxhalf{ib},:);
            EU  = zeros(180,6);
            for i = 1:length(idxhalf{ib})
                if      expected_unc_type(i) == 1
                        EU(i,1) = precent_acc(i);
                elseif  expected_unc_type(i) == 2
                        EU(i,2) = precent_acc(i);
                elseif  expected_unc_type(i) == 3
                        EU(i,3) = precent_acc(i);  
                elseif  expected_unc_type(i) == 4
                        EU(i,4) = precent_acc(i);  
                elseif  expected_unc_type(i) == 5
                        EU(i,5) = precent_acc(i);        
                else
                        EU(i,6) = precent_acc(i);
            
                end
        
           end 
           
            EU1 = mean(nonzeros(EU(:,1)));
            EU2 = mean(nonzeros(EU(:,2)));
            EU3 = mean(nonzeros(EU(:,3)));
            EU4 = mean(nonzeros(EU(:,4)));
            EU5 = mean(nonzeros(EU(:,5)));
            EU6 = mean(nonzeros(EU(:,6)));
            
            exploration_exploitation = zeros(100,3);
            for i = 1:length(idxhalf{ib})
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0;
                        exploration_exploitation(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0;
                        exploration_exploitation(i,2) = 1;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        exploration_exploitation(i,3) = 1;
            
                end
        
            end 
            exploitation  = sum(exploration_exploitation(:,1));
            d_exploration = sum(exploration_exploitation(:,2));
            r_exploration = sum(exploration_exploitation(:,3));
            
            choice = get_from_mat(s.sub{isub}.pmat, {'choice'});
            choice = choice(idxhalf{ib},:);
            unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
            unc_left = unc_left(idxhalf{ib},:);
            unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
            unc_right = unc_right(idxhalf{ib},:);
            TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
            V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
            V = V(idxhalf{ib},:);
            RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
            RU = RU(idxhalf{ib},:);
            B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
            B = B(idxhalf{ib},:);
            tbl = table(choice,V,RU,B,TU);
            formula = 'choice ~ -1 + V + TU + RU + B';
            
            % c. fit logistic GLM:
            beta  = glmfit(reg,choice, 'binomial','link','logit');
         
            glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace');
          
            w = fixedEffects(glme);
            % d. save
            allval{2}.betas{ib}(isub,:)     = beta;
            allval{2}.regnames              = pickregs;
            allval{2}.GLMtype               = 'decphase_blockhalves';
            allval{2}.glmename              = pickglme;
            allval{2}.glmebetas{ib}(isub,:) = w;
            allval{2}.exploitation{ib}(isub,:) = exploitation;
            allval{2}.d_exploration{ib}(isub,:) = d_exploration;
            allval{2}.r_exploration{ib}(isub,:) = r_exploration;
            allval{2}.mean_ci{ib}(isub,:)       = mci;
            allval{2}.mean_t_unc{ib}(isub,:)    = mt_unc;
            allval{2}.angle_error{ib}(isub,:)    = mean_angle;
            allval{2}.sum_repetition{ib}(isub,:)    = s_repetition;
            allval{2}.acc_type{ib}(isub,:)          = acc_type;
            allval{2}.EV1{ib}(isub,:)          = EV1;
            allval{2}.EV2{ib}(isub,:)          = EV2;
            allval{2}.EV3{ib}(isub,:)          = EV3;
            allval{2}.EV4{ib}(isub,:)          = EV4;
            allval{2}.EV5{ib}(isub,:)          = EV5;
            allval{2}.EV6{ib}(isub,:)          = EV6;
            allval{2}.EU1{ib}(isub,:)          = EU1;
            allval{2}.EU2{ib}(isub,:)          = EU2;
            allval{2}.EU3{ib}(isub,:)          = EU3;
            allval{2}.EU4{ib}(isub,:)          = EU4;
            allval{2}.EU5{ib}(isub,:)          = EU5;
            allval{2}.EU6{ib}(isub,:)          = EU6;
            
 %%choice prediction
 
       w1 = allval{2}.betas{ib}(isub,2);
       w2 = allval{2}.betas{ib}(isub,3);
       

       acc_left = get_from_mat(s.sub{isub}.pmat, {'acc_left'});
       acc_left = acc_left(idxhalf{ib},:);
       acc_right = get_from_mat(s.sub{isub}.pmat, {'acc_right'});
       acc_right = acc_right(idxhalf{ib},:);
       unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'});
       unc_left = unc_left(idxhalf{ib},:);
       unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'});
       unc_right = unc_right(idxhalf{ib},:);
       
       
       
       u_left = w1 * acc_left + w2*unc_left ;
       u_right = w1 * acc_right + w2*unc_right;
       
       
       choice_prediction = zeros(length(idxhalf{ib}),1);
       prediction_ratio = zeros(length(idxhalf{ib}),1);
       for i = 1:length(idxhalf{ib})
           if u_left(i) > u_right(i)
               choice_prediction(i) = 1;
           else
               choice_prediction(i) = 0;
           end
           
           
           
           if choice_prediction(i) == choice(i)
               prediction_ratio(i) = 1;
           else
               prediction_ratio(i) = 0;
           end
           
       end
       prediction_r = sum(prediction_ratio/length(idxhalf{ib}));
       
       allval{2}.choice_prediction{ib}(:,isub)          = choice_prediction;
       allval{2}.prediction_r{ib}(isub,:)               = prediction_r;
            
        end
    end
end





%% GLM 3. Time horizon


if run(3) == 1
    reg=[];pickregs={};pickregs={'diff_acc','diff_unc'};
    for isub = 1:length(s.ID)
        % a. takes the first 15 trials of each time horizon
        eval('split_allhorizon_half')
        for ib = 1:6 %loop through time horizons (long=45,medium=30,short=15)
            
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg = reg(horizonidx{ib},:); 
            choice = get_from_mat(s.sub{isub}.pmat, {'choice'});
            choice = choice(horizonidx{ib},:);
            
            chounch_acc = get_from_mat(s.sub{isub}.pmat, {'chounch_acc'});
            chounch_acc = chounch_acc(horizonidx{ib},:);
            chounch_unc = get_from_mat(s.sub{isub}.pmat, {'chounch_unc'});
            chounch_unc = chounch_unc(horizonidx{ib},:);
            angle_error = get_from_mat(s.sub{isub}.pmat, {'angle_error'});
            angle_error = angle_error(horizonidx{ib},:);
            mean_angle  = mean(angle_error);
            exploration_exploitation = zeros(100,3);
            
            for i = 1:length(horizonidx{ib})
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0;
                        exploration_exploitation(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0;
                        exploration_exploitation(i,2) = 1;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        exploration_exploitation(i,3) = 1;
            
                end
        
            end 
            exploitation  = sum(exploration_exploitation(:,1));
            d_exploration = sum(exploration_exploitation(:,2));
            r_exploration = sum(exploration_exploitation(:,3));
            
            beta  =robustfit(reg,choice); 
            %save
           
            allval{7}.betas{ib}(isub,:)     = beta;
            allval{7}.exploitation{ib}(isub,:) = exploitation;
            allval{7}.d_exploration{ib}(isub,:) = d_exploration;
            allval{7}.r_exploration{ib}(isub,:) = r_exploration;
            allval{7}.angle_error{ib}(isub,:) = mean_angle;
        end
    end
    
end

if run(3) == 1
  
    for isub = 1:length(s.ID)
        % a. takes the first 15 trials of each time horizon
        eval('split_5trials_eachhorizon')
        for ib = 1:18 %loop through time horizons (long=45,medium=30,short=15)
                      
            chounch_acc = get_from_mat(s.sub{isub}.pmat, {'chounch_acc'});
            chounch_acc = chounch_acc(horizonidx{ib},:);
            chounch_unc = get_from_mat(s.sub{isub}.pmat, {'chounch_unc'});
            chounch_unc = chounch_unc(horizonidx{ib},:);
            exploration_exploitation = zeros(100,3);
            
            for i = 1:length(horizonidx{ib})
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0;
                        exploration_exploitation(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0;
                        exploration_exploitation(i,2) = 1;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        exploration_exploitation(i,3) = 1;
            
                end
        
            end 
            exploitation  = sum(exploration_exploitation(:,1));
            d_exploration = sum(exploration_exploitation(:,2));
            r_exploration = sum(exploration_exploitation(:,3));
            
           
            %save
           
            allval{6}.exploitation{ib}(isub,:) = exploitation;
            allval{6}.d_exploration{ib}(isub,:) = d_exploration;
            allval{6}.r_exploration{ib}(isub,:) = r_exploration;
        end
    end
    
end

if run(3) == 1
    disp('running GLM3...')
    reg=[];pickregs={};pickregs={'diff_acc','diff_unc'};
    V = [];TU = [];RU = [];B = [];
    pickglme = {};pickglme = {'V','RU','B','TU'};
    for isub = 1:length(s.ID)
        % a. split trials into first 15 trials of each time horizon:
        eval('split_timehorizon')
        for ib = 1:3 %loop through time horizons (long=45,medium=30,short=15)
            % b. regressors:
            reg    = [];
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg    = normalise(reg(horizonidx{ib},:));                      % regressos are normalised within block halves
            
            chounch_acc = get_from_mat(s.sub{isub}.pmat, {'chounch_acc'});
            chounch_acc = chounch_acc(horizonidx{ib},:);
            chounch_unc = get_from_mat(s.sub{isub}.pmat, {'chounch_unc'});
            chounch_unc = chounch_unc(horizonidx{ib},:);
            exploration_exploitation = zeros(100,3);
            
            for i = 1:length(horizonidx{ib})
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0
                        exploration_exploitation(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0
                        exploration_exploitation(i,2) = 1;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        exploration_exploitation(i,3) = 1;
            
                end
        
            end 
            exploitation  = sum(exploration_exploitation(:,1));
            d_exploration = sum(exploration_exploitation(:,2));
            r_exploration = sum(exploration_exploitation(:,3));
            
            choice = [];
            choice = get_from_mat(s.sub{isub}.pmat, {'choice'});
            choice = choice(horizonidx{ib},:);
            
            unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
            unc_left = unc_left(horizonidx{ib},:);
            unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
            unc_right = unc_right(horizonidx{ib},:);
            TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
            V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
            V = V(horizonidx{ib},:);
            RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
            RU = RU(horizonidx{ib},:);
            B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
            B = B(horizonidx{ib},:);
            tbl = table(choice,V,RU,B,TU);
            formula = 'choice ~ -1 + V + TU + RU + B';
            % c. fit logistic GLM:
            beta  =robustfit(reg,choice);                            % results can be replicated when using t-stats of a logistic regression; see Methods part of Trudel 2020 NHB
      
            glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace','PLIterations',200);
      
            w = fixedEffects(glme);
            % d. save
            allval{3}.betas{ib}(isub,:)     = beta;
            allval{3}.regnames              = pickregs;
            allval{3}.GLMtype               = 'decphase_timehorizon';
            allval{3}.glmename              = pickglme;
            allval{3}.glmebetas{ib}(isub,:) = w;
            allval{3}.exploitation{ib}(isub,:) = exploitation;
            allval{3}.d_exploration{ib}(isub,:) = d_exploration;
            allval{3}.r_exploration{ib}(isub,:) = r_exploration;
        end
    end
    
end




%% GLME all timehorizon
if run(3) == 1
    
    disp('GLME all timehorizon')
    
    reg=[];pickregs={};pickregs={'diff_acc','diff_unc'};
    V = [];TU = [];RU = [];B = [];
    pickglme = {};pickglme = {'V','RU','B','TU'};
    for isub = 1:length(s.ID)
        % a. split trials into first all trials of each time horizon:
        eval('split_allhorizon')
        for ib = 1:3 %loop through time horizons (long=45,medium=30,short=15)
            % b. regressors:
            reg    = [];
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg    = normalise(reg(horizonidx{ib},:));                      % regressos are normalised within block halves
            
            
            chounch_acc = get_from_mat(s.sub{isub}.pmat, {'chounch_acc'});
            chounch_acc = chounch_acc(horizonidx{ib},:);
            chounch_unc = get_from_mat(s.sub{isub}.pmat, {'chounch_unc'});
            chounch_unc = chounch_unc(horizonidx{ib},:);
            angle_error = get_from_mat(s.sub{isub}.pmat, {'angle_error'});
            angle_error = angle_error(horizonidx{ib},:);
            mean_angle  = mean(angle_error);
            precent_unc = get_from_mat(s.sub{isub}.pmat, {'precent_unc'});
            precent_unc = precent_unc(horizonidx{ib},:);
            expected_value_type = get_from_mat(s.sub{isub}.pmat, {'expected_value_type'});
            expected_value_type = expected_value_type(horizonidx{ib},:);
            EV  = zeros(180,6);
            for i = 1:length(horizonidx{ib})
                if      expected_value_type(i) == 1
                        EV(i,1) = precent_unc(i);
                elseif  expected_value_type(i) == 2
                        EV(i,2) = precent_unc(i);
                elseif  expected_value_type(i) == 3
                        EV(i,3) = precent_unc(i);  
                elseif  expected_value_type(i) == 4
                        EV(i,4) = precent_unc(i);  
                elseif  expected_value_type(i) == 5
                        EV(i,5) = precent_unc(i);        
                else
                        EV(i,6) = precent_unc(i);
            
                end
        
            end 
           
            EV1 = mean(nonzeros(EV(:,1)));
            EV2 = mean(nonzeros(EV(:,2)));
            EV3 = mean(nonzeros(EV(:,3)));
            EV4 = mean(nonzeros(EV(:,4)));
            EV5 = mean(nonzeros(EV(:,5)));
            EV6 = mean(nonzeros(EV(:,6)));
            
            precent_acc = get_from_mat(s.sub{isub}.pmat, {'precent_acc'});
            precent_acc = precent_acc(horizonidx{ib},:);
            expected_unc_type = get_from_mat(s.sub{isub}.pmat, {'expected_unc_type'});
            expected_unc_type = expected_unc_type(horizonidx{ib},:);
            EU  = zeros(180,6);
            for i = 1:length(horizonidx{ib})
                if      expected_unc_type(i) == 1
                        EU(i,1) = precent_acc(i);
                elseif  expected_unc_type(i) == 2
                        EU(i,2) = precent_acc(i);
                elseif  expected_unc_type(i) == 3
                        EU(i,3) = precent_acc(i);  
                elseif  expected_unc_type(i) == 4
                        EU(i,4) = precent_acc(i);  
                elseif  expected_unc_type(i) == 5
                        EU(i,5) = precent_acc(i);        
                else
                        EU(i,6) = precent_acc(i);
            
                end
        
           end 
           
            EU1 = mean(nonzeros(EU(:,1)));
            EU2 = mean(nonzeros(EU(:,2)));
            EU3 = mean(nonzeros(EU(:,3)));
            EU4 = mean(nonzeros(EU(:,4)));
            EU5 = mean(nonzeros(EU(:,5)));
            EU6 = mean(nonzeros(EU(:,6)));
            
            
            exploration_exploitation = zeros(100,3);
            
            for i = 1:length(horizonidx{ib})
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0
                        exploration_exploitation(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0
                        exploration_exploitation(i,2) = 1;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        exploration_exploitation(i,3) = 1;
            
                end
        
            end 
            exploitation  = sum(exploration_exploitation(:,1));
            d_exploration = sum(exploration_exploitation(:,2));
            r_exploration = sum(exploration_exploitation(:,3));
            
            choice = [];
            choice = get_from_mat(s.sub{isub}.pmat, {'choice'});
            choice = choice(horizonidx{ib},:);
            unc_left = get_from_mat(s.sub{isub}.pmat, {'unc_left'}); 
            unc_left = unc_left(horizonidx{ib},:);
            unc_right = get_from_mat(s.sub{isub}.pmat, {'unc_right'}); 
            unc_right = unc_right(horizonidx{ib},:);
            TU = normalise(sqrt(unc_left.^2 + unc_right.^2));
            V = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_acc')); 
            V = V(horizonidx{ib},:);
            RU = normalise(get_from_mat(s.sub{isub}.pmat, 'diff_unc')); 
            RU = RU(horizonidx{ib},:);
            B = normalise(get_from_mat(s.sub{isub}.pmat, 'blocktime')); 
            B = B(horizonidx{ib},:);
            tbl = table(choice,V,RU,B,TU);
            formula = 'choice ~ -1 + V + TU + RU + B';
            % c. fit logistic GLM:
            beta  =robustfit(reg,choice);                            % results can be replicated when using t-stats of a logistic regression; see Methods part of Trudel 2020 NHB
            
            glme = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace','PLIterations',200);

            w = fixedEffects(glme);
            % d. save
            allval{5}.betas{ib}(isub,:)     = beta;
            allval{5}.regnames              = pickregs;
            allval{5}.GLMtype               = 'decphase_allhorizon';
            allval{5}.glmename              = pickglme;
            allval{5}.glmebetas{ib}(isub,:) = w;
            allval{5}.exploitation{ib}(isub,:) = exploitation;
            allval{5}.d_exploration{ib}(isub,:) = d_exploration;
            allval{5}.r_exploration{ib}(isub,:) = r_exploration;
            allval{5}.angle_error{ib}(isub,:) = mean_angle;
            allval{5}.EV1{ib}(isub,:)          = EV1;
            allval{5}.EV2{ib}(isub,:)          = EV2;
            allval{5}.EV3{ib}(isub,:)          = EV3;
            allval{5}.EV4{ib}(isub,:)          = EV4;
            allval{5}.EV5{ib}(isub,:)          = EV5;
            allval{5}.EV6{ib}(isub,:)          = EV6;
            allval{5}.EU1{ib}(isub,:)          = EU1;
            allval{5}.EU2{ib}(isub,:)          = EU2;
            allval{5}.EU3{ib}(isub,:)          = EU3;
            allval{5}.EU4{ib}(isub,:)          = EU4;
            allval{5}.EU5{ib}(isub,:)          = EU5;
            allval{5}.EU6{ib}(isub,:)          = EU6;
        end
    end
    
end


%%block pe
if run(3) == 1
  
    for isub = 1:length(s.ID)
       
        eval('split_block')
        for ib = 1:6 %loop 
 
            angle_error = get_from_mat(s.sub{isub}.pmat, {'angle_error'});
            angle_error = angle_error(block{ib},:);
            a_pe = zeros(length(angle_error),1);
            for i = 1:length(angle_error)-1
                a_pe(i+1) = mean(angle_error(1:i,1));
            end
                
            
            % d. save
           
           allval{8}.a_pe{ib}(:,isub)          = a_pe;
            
        end
    end
    
end


%% GLM 4. Confidence judgment
if run(4) == 1
    
    disp('running GLM4...')
    
    reg=[];pickregs={};pickregs={'chosen_acc','chosen_unc'};
    for isub = 1:length(s.ID)
        % a. regressors:
        reg       = normalise(get_from_mat(s.sub{isub}.pmat, pickregs));     % regressos are normalised across all trials
        Cinterval = get_from_mat(s.sub{isub}.pmat, {'cisize'});
        
        % b. fit linear GLM:
        beta  = glmfit(reg,Cinterval, 'normal','link','identity');
        
        % c. save
        allval{4}.betas(isub,:)         = beta;
        allval{4}.regnames              = pickregs;
        allval{4}.GLMtype               = 'confphase_confjudg';
    end
end


if run(4) == 1
    
    disp('running GLM4...')
    
    reg=[];pickregs={};pickregs={'angle_error','blocktime','abs_PExb'};
    for isub = 1:length(s.ID)
        % a. regressors:
        reg       = normalise(get_from_mat(s.sub{isub}.pmat, pickregs));     % regressos are normalised across all trials
        Cinterval = get_from_mat(s.sub{isub}.pmat, {'chosen_unc'});
        
        % b. fit linear GLM:
        beta  = glmfit(reg,Cinterval, 'normal','link','identity');
        
        % c. save
        allval{11}.betas(isub,:)         = beta;
        allval{11}.regnames              = pickregs;
        allval{11}.GLMtype               = 'chosen_unc_PE';
    end
end


if run(4) == 1
    
    disp('running GLM4...')
    
    reg=[];pickregs={};pickregs={'angle_error','blocktime','abs_PExb'};
    for isub = 1:length(s.ID)
        % a. regressors:
        reg       = normalise(get_from_mat(s.sub{isub}.pmat, pickregs));     % regressos are normalised across all trials
        Cinterval = get_from_mat(s.sub{isub}.pmat, {'chosen_acc'});
        
        % b. fit linear GLM:
        beta  = glmfit(reg,Cinterval, 'normal','link','identity');
        
        % c. save
        allval{12}.betas(isub,:)         = beta;
        allval{12}.regnames              = pickregs;
        allval{12}.GLMtype               = 'chosen_acc_PE';
    end
end


if run(4) == 1
    
    disp('running GLM4...')
    
    reg=[];pickregs={};pickregs={'chosen_acc','chosen_unc','blocktime'};
    for isub = 1:length(s.ID)
        % a. regressors:
        reg       = normalise(get_from_mat(s.sub{isub}.pmat, pickregs));     % regressos are normalised across all trials
        Cinterval = get_from_mat(s.sub{isub}.pmat, {'angle_error'});
        
        % b. fit linear GLM:
        beta  = glmfit(reg,Cinterval, 'normal','link','identity');
        
        % c. save
        allval{13}.betas(isub,:)         = beta;
        allval{13}.regnames              = pickregs;
        allval{13}.GLMtype               = 'abs_PE_chosen';
    end
end

%% GLM 1. Across all trials
if run(1) == 1
    
    disp('running GLM5...')
    
    reg = [];
    pickregs = {};
    pickregs = {'diff_acc','diff_unc','diff_pe', 'blocktime', 'diff_uncxblocktime', 'diff_accxblocktime','diff_pexb'};
    for isub = 1:length(s.ID)
        % a. regressors:
        reg    = normalise(get_from_mat(s.sub{isub}.pmat, pickregs)); % regressos are normalised across all trials
        choice = get_from_mat(s.sub{isub}.pmat, {'choice'});

         %b. fit logistic GLM:
        beta  = glmfit(reg,choice, 'binomial','link','logit');
        
        % c. save
        allval{9}.betas(isub,:)         = beta;
        allval{9}.regnames              = pickregs;
        allval{9}.GLMtype               = 'decphase_alltrials';
       
  
       
    end
end
    
%% GLM 2. Block halves
if run(2) == 1
    
    disp('running GLM6...')
    
    reg=[];pickregs={};pickregs={'diff_acc','diff_unc','diff_pe'};
    
    for isub = 1:length(s.ID)
        % a. split trials:
        eval('split_blockhalves')
        for ib = 1:2 %loop through block halves
            % b. regressors:
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg    = normalise(reg(idxhalf{ib},:));                            % regressos are normalised within block halves
            choice = get_from_mat(s.sub{isub}.pmat, {'choice'});
            choice = choice(idxhalf{ib},:);
           
            
            % c. fit logistic GLM:
            beta  = glmfit(reg,choice, 'binomial','link','logit');

            % d. save
            allval{10}.betas{ib}(isub,:)     = beta;
            allval{10}.regnames              = pickregs;
            allval{10}.GLMtype               = 'decphase_blockhalves';
            
            
            
        end
    end
end


if run(2) == 1
    
    disp('running GLM6...')
    
    reg=[];pickregs={};pickregs={'angle_error','blocktime','abs_PExb'};
    
    for isub = 1:length(s.ID)
        % a. split trials:
        eval('split_blockhalves')
        for ib = 1:2 %loop through block halves
            % b. regressors:
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg    = normalise(reg(idxhalf{ib},:));                            % regressos are normalised within block halves
            choice = get_from_mat(s.sub{isub}.pmat, {'chosen_unc'});
            choice = choice(idxhalf{ib},:);
           
            
            % c. fit logistic GLM:
            beta  = glmfit(reg,choice, 'normal','link','identity');

            % d. save
            allval{14}.betas{ib}(isub,:)     = beta;
            allval{14}.regnames              = pickregs;
            allval{14}.GLMtype               = 'decphase_blockhalves';
            
            
            
        end
    end
end


if run(2) == 1
    
    disp('running GLM6...')
    
    reg=[];pickregs={};pickregs={'angle_error','blocktime','abs_PExb'};
    
    for isub = 1:length(s.ID)
        % a. split trials:
        eval('split_blockhalves')
        for ib = 1:2 %loop through block halves
            % b. regressors:
            reg    = get_from_mat(s.sub{isub}.pmat, pickregs);
            reg    = normalise(reg(idxhalf{ib},:));                            % regressos are normalised within block halves
            choice = get_from_mat(s.sub{isub}.pmat, {'chosen_acc'});
            choice = choice(idxhalf{ib},:);
           
            
            % c. fit logistic GLM:
            beta  = glmfit(reg,choice, 'normal','link','identity');

            % d. save
            allval{15}.betas{ib}(isub,:)     = beta;
            allval{15}.regnames              = pickregs;
            allval{15}.GLMtype               = 'decphase_blockhalves';
            
            
            
        end
    end
end



end