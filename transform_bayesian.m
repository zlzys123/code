function [s] = transform_bayesian(s,ntr,npred)
%% this script transforms values from the Bayesian model into a mat file which can be used in later analyses
    
    
    for isub = 1:length(s.ID) % loop through subjects
            pred_order = s.sub{isub}.pred_order;   
         
        for estimate = 1:2 % loop through bayesian estimates            
            
            clearvars -except s estimate isub calcu fprint choice orig_adv pred_order ntr npred
             
            idx      = ones(1,24); pred_idx = ones(1,24);
                  
           %loops through parameter:
           if estimate == 1                                                   
               bayes_est = s.sub{isub}.bayes.presout{isub}.comb.maxval_acc;
           elseif estimate ==2
               bayes_est = s.sub{isub}.bayes.presout{isub}.comb.unc_range;
           end

 
            choice = get_from_mat(s.sub{isub}.logfile, 'choice');

 
                for i=1:length(pred_order)
                                
                    leftrightpic = double(pred_order(:, 1) == choice);
                    leftrightpic(leftrightpic==0)=2;                        % right = 2; left = 1;
                    
                    options = pred_order(i,:);
                    chosen_side = leftrightpic(i);
                    chosen_id = choice(i);
                    
                   
                    
                    dat(i,chosen_side) = bayes_est (pred_idx(chosen_id),chosen_id);
        
                    
                    chosen_mat(i,:) = dat(i,chosen_side);
                    
                    nonchosen_side = 3-chosen_side;
                    nonchosen_id = options(nonchosen_side);
                    
                    
                    dat(i,nonchosen_side) = bayes_est (pred_idx(nonchosen_id),nonchosen_id);
                    nonchosen_mat(i,:) = dat(i,nonchosen_side);
                    
                    idx (i,:) = pred_idx;
                    pred_idx(chosen_id) = pred_idx(chosen_id)+1;
                    
                    if i == ntr
                        idx (i,:) = pred_idx;
                    end
                end
                
                
                %%% have to seperate for each advisor
                if estimate ==1
                    clearvars  ia pred_idx mat_value  offer;
                end
               
                for ia = 1:npred
                    adv_id=idx(:,ia);
                    mat_value = bayes_est (:,ia);
                    offer(ia,:)= mat_value(adv_id);
                end
                
                % set to Nan if advisor not in current option set
                offer = offer';
                offernan     = offer;
                for ia =  1: npred
                    for i = 1:length(pred_order),
                        cur_adv     = ia;
                        cur_options = pred_order(i,:);
                        
                        if ~ismember(cur_adv, cur_options),                                 % set to Nan if advisor not in current option set
                            offernan(i,ia)  = NaN;
                        end;
                    end;
                end
                
                
                s.sub{isub}.transform.choice.adv         =  choice;
                s.sub{isub}.transform.choice.leftright   = leftrightpic;
                
   % save into structure:
   
                output.offernan      = offernan;
                output.chosen_mat    = chosen_mat;
                output.nonchosen_mat = nonchosen_mat;
                output.dat           = dat;
                output.estimate      = estimate;

                   
                    if estimate ==1
                        s.sub{isub}.transform.maxval_acc = output;
                    elseif estimate ==2
                        s.sub{isub}.transform.unc_range = output;
                    end
                    
        end
    end
end


