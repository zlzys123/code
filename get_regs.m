function [s] = get_regs(s)
%% all reg of interest
% either calculates regressors or sorts regressors that are already calculated
%
%
%
%% 1) names:
pmat = {};

topick = {'choice';'acc_left';'acc_right';'unc_left';'unc_right';'diff_acc';'diff_unc';'tol_unc';...
    'norm_v';'norm_ru';'norm_tu';'chosen_acc';'chosen_unc';'unchosen_acc';'unchosen_unc';'chounch_acc';'chounch_unc';...
    'blocktime';'cisize';'payoff';'diff_accxblocktime';'diff_uncxblocktime';'tol_uncxblocktime';'diff_accxb_nonorm';...
    'diff_uncxb_nonorm';'tol_uncxb_nonorm';'blockidx';'type';'half_type';'horizon_type';'cho_plus_uncho_acc';'cho_plus_uncho_unc';...
    'chosen_uti';'unchosen_uti';'cho_plus_uncho_uti';'cho_con_uncho_uti';'precent_acc';'precent_unc';'expected_value';'expected_value_type';...
    'expected_unc';'expected_unc_type';'accxb_left';'accxb_right';'uncxb_left';'uncxb_right';'angle_error';'abs_PExb';...
    'PE';'outcome';'repetition';'acc_type';'left_option';'right_option';'chosen';'unchosen'; 'chosen_pe';'unchosen_pe';'left_pe';'right_pe';...
    '1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20';'21';'22';'23';'24';'diff_pe';'diff_pexb'};



%% 2) pmat:
% pmat = parameter mat file


for isub = 1:length(s.ID)  % loop through subjects
    pmat.names(:,1) = topick;
    
    % a. behavioural regressors:
    adv_pick       = s.sub{isub}.transform.choice.adv;
    choice         = s.sub{isub}.transform.choice.leftright; choice(choice ==2) =0;
    acc_left       = s.sub{isub}.transform.maxval_acc.dat(:,1);
    acc_right      = s.sub{isub}.transform.maxval_acc.dat(:,2);
    unc_left       = s.sub{isub}.transform.unc_range.dat(:,1);
    unc_right      = s.sub{isub}.transform.unc_range.dat(:,2);
    diff_acc       = acc_left - acc_right;
    diff_unc       = unc_left - unc_right;
    tol_unc        = sqrt(unc_left.^2 + unc_right.^2);
    norm_v         = normalise(diff_acc);
    norm_ru        = normalise(diff_unc);
    norm_tu        = normalise(tol_unc);
    
    repetition     = zeros(180,1);       
    for i = 2:180
                if      adv_pick(i) == adv_pick(i-1)
                        repetition(i,1) = 1;
               
                elseif  adv_pick(i) ~= adv_pick(i-1)
                        repetition(i,1) = 0;
            
                end
        
    end 
    
    repetition(1,1) = 0; repetition(16,1) = 0; repetition(46,1) = 0; repetition(91,1) = 0; repetition(106,1) = 0; repetition(136,1) = 0; 
    
    
    % b. behavioural regressor for confidence judgment analysis
    %    and neural regressors:
    chosen_acc         = s.sub{isub}.transform.maxval_acc.chosen_mat;
    chosen_unc         = s.sub{isub}.transform.unc_range.chosen_mat;
    unchosen_acc       = s.sub{isub}.transform.maxval_acc.nonchosen_mat;
    unchosen_unc       = s.sub{isub}.transform.unc_range.nonchosen_mat;
    
    chounch_acc        = chosen_acc - unchosen_acc;
    chounch_unc        = chosen_unc - unchosen_unc;
    
    cho_plus_uncho_acc = chosen_acc + unchosen_acc;
    cho_plus_uncho_unc = chosen_unc + unchosen_unc;
    
    chosen_uti         = chosen_acc + chosen_unc;
    unchosen_uti       = unchosen_acc + unchosen_unc;
    cho_plus_uncho_uti = chosen_uti  + unchosen_uti;
    cho_con_uncho_uti  = chosen_uti  - unchosen_uti;
    
    precent_acc        = 1 - chosen_acc./cho_plus_uncho_acc;
    precent_unc        = chosen_unc./cho_plus_uncho_unc;
    
    expected_value = zeros(180,1);       
    for i = 1:180
                if      chosen_unc(i) > unchosen_unc(i)
                        expected_value(i,1) = chosen_acc(i) - unchosen_acc(i);
               
                else
                        expected_value(i,1) = unchosen_acc(i) - chosen_acc(i);
            
                end
        
    end 
    expected_unc = zeros(180,1);       
    for i = 1:180
                if      chosen_acc(i) > unchosen_acc(i)
                        expected_unc(i,1) = chosen_unc(i) - unchosen_unc(i);
               
                else
                        expected_unc(i,1) = unchosen_unc(i) - chosen_unc(i);
            
                end
        
    end 

    expected_value_type = zeros(180,1);       
    for i = 1:180
                if      expected_value(i) <= -40
                        expected_value_type(i,1) = 1;
                elseif  expected_value(i) > -40  && expected_value(i) <= -20
                        expected_value_type(i,1) = 2;
                elseif  expected_value(i) > -20  && expected_value(i) <= 0
                        expected_value_type(i,1) = 3;
                elseif  expected_value(i) > 0  && expected_value(i) <= 20
                        expected_value_type(i,1) = 4;
                elseif  expected_value(i) > 20  && expected_value(i) <= 40
                        expected_value_type(i,1) = 5;  
                else  
                        expected_value_type(i,1) = 6;  
                end
        
    end 
    expected_unc_type = zeros(180,1);       
    for i = 1:180
                if      expected_unc(i) <= -40
                        expected_unc_type(i,1) = 1;
                elseif  expected_unc(i) > -40  && expected_unc(i) <= -20
                        expected_unc_type(i,1) = 2;
                elseif  expected_unc(i) > -20  && expected_unc(i) <= 0
                        expected_unc_type(i,1) = 3;
                elseif  expected_unc(i) > 0  && expected_unc(i) <= 20
                        expected_unc_type(i,1) = 4;
                elseif  expected_unc(i) > 20  && expected_unc(i) <= 40
                        expected_unc_type(i,1) = 5;  
                else  
                        expected_unc_type(i,1) = 6;  
                end
        
    end 
    % c. block time
    blocknr = get_from_mat(s.sub{isub}.logfile, 'blocknr');
    
    
    blocktime=[];blockidx=[];
    blockorder = find(blocknr~=0);
    for ib = 1:length(blockorder)
        curit = blocknr(blockorder(ib));
        if curit ==1||curit==4; idx =45; elseif curit==2||curit==5; idx=30; elseif curit ==3||curit==6; idx=15;end
        blocktime   = [blocktime sort(1:idx,'descend')/idx];
        blockidx = [blockidx; zeros(idx,1)+curit];
    end

    
    % d. Confidence interval:
    CI_curstep  =  get_from_mat(s.sub{isub}.logfile, 'curstep');
    payoff      = get_from_mat(s.sub{isub}.logfile, 'payoff'); 
    diff_advflo = get_from_mat(s.sub{isub}.logfile, 'diff_advflo'); 
    CI_size     = get_from_mat(s.sub{isub}.logfile, 'CI_size');
    abs_PE      = abs(CI_size - abs(diff_advflo));
    PE          = CI_size - abs(diff_advflo);
    AE          = abs(diff_advflo);
    
    % e. interaction terms:
    diff_accxblocktime = normalise(diff_acc).*normalise(blocktime)';
    diff_uncxblocktime = normalise(diff_unc).*normalise(blocktime)';
    tol_uncxblocktime  = normalise(tol_unc).*normalise(blocktime)';
    diff_accxb_nonorm  = diff_acc.*blocktime';
    diff_uncxb_nonorm  = diff_unc.*blocktime';
    tol_uncxb_nonorm   = tol_unc.*blocktime';
    accxb_left         = acc_left.*blocktime';
    accxb_right        = acc_right.*blocktime';
    uncxb_left         = unc_left.*blocktime';
    uncxb_right        = unc_right.*blocktime';
    abs_PExb           = abs_PE.*blocktime';
    
    %PE
    left_option = s.sub{isub}.pred_order(:,1);
    right_option = s.sub{isub}.pred_order(:,2);
    unchosen = zeros(180,1);
    for i = 1:180
        if choice(i) == 1
           unchosen(i) = right_option(i);
        else
           unchosen(i) = left_option(i);
        end
    end
    chosen = adv_pick;
    
    op_pe = ones(180,24)*3.142;
    for i = 1:179
        for j = 1:24
            if chosen(i)==j
                op_pe(i+1,j) = abs_PE(i);
            else
                op_pe(i+1,j) = op_pe(i,j);
            end
        end
    end   
    
    chosen_pe = ones(180,1)*3.142;
    unchosen_pe = ones(180,1)*3.142;
    for i = 1:180
        a = chosen(i);
        b = unchosen(i);
       
        chosen_pe(i,1) = op_pe(i,a);
        unchosen_pe(i,1) = op_pe(i,b);
    end
    
    left_pe = ones(180,1)*3.142;
    right_pe = ones(180,1)*3.142;
    for i = 1:180
        a = left_option(i);
        b = right_option(i);
        
        left_pe(i,1) = op_pe(i,a);
        right_pe(i,1) = op_pe(i,b);
    end
    
    diff_pe = left_pe - right_pe;
    diff_pexb  = diff_pe.*blocktime';
    %f. type
    type = zeros(180,1);       
    for i = 1:180
                if      chounch_acc(i)>0 && chounch_acc(i)-chounch_unc(i)>0
                        type(i,1) = 1;
                elseif  chounch_unc(i)>0 && chounch_unc(i)-chounch_acc(i)>0
                        type(i,1) = 2;
                else
                        chounch_acc(i)<0 && chounch_unc(i)<0; 
                        type(i,1) = 3;
            
                end
        
    end 
    
    acc_type = zeros(180,1);
     for i = 1:180
         if      chounch_acc(i)>0
                 acc_type(i,1) = 0;
         
         elseif  chounch_acc(i)<0
                 acc_type(i,1) = 1;
         else    
                 acc_type(i,1) = 0;
         end
     end
     
    %half_type
    
    bID = 6; btrials=[];half_type = zeros(180,1);
    for bidx = 1:bID
    btrials  = find(blockidx==bidx);
    bsize    = length(btrials);
    splitidx = round(bsize/2);
      for i = 1:bsize
          if    btrials(i) <= btrials(1) + splitidx -1
                half_type(btrials(i),1) = 1;
          else  
                half_type(btrials(i),1) = 2;
          end
      end
    end
    
    %horizon_type
    
    bID = 6; btrials=[];horizon_type = zeros(180,1);
    for bidx = 1:bID
    btrials  = find(blockidx==bidx);
    bsize    = length(btrials);
  
      for i = 1:bsize
          if    btrials(i) <= btrials(1) + 14
                horizon_type(btrials(i),1) = 1;
          else  
                horizon_type(btrials(i),1) = 0;
          end
      end
    end
    
%     old=load('cond15-Jan-2020.mat');
%     
%     vars_old= abs(get_from_mat(old.cond{2}.sub{isub}.pmat, {'choice';'diff_acc';'diff_unc';'percleft';'diff_uncxpercleft';'diff_accxpercleft'}));
%     vars_new = abs([choice diff_acc diff_unc blocktime' diff_uncxblocktime diff_accxblocktime]);
%     
%     varsum = sum(sum((vars_old-vars_new)));
%     
%     if varsum ~= 0
%         keyboard
%     end
%     
    
    
    
    % f. save into pmat:
    im =1;
    pmat.mat(:,im) = choice;                im = im + 1;
    pmat.mat(:,im) = acc_left;              im = im + 1;
    pmat.mat(:,im) = acc_right;             im = im + 1;
    pmat.mat(:,im) = unc_left;              im = im + 1;
    pmat.mat(:,im) = unc_right;             im = im + 1;
    pmat.mat(:,im) = diff_acc;              im = im + 1;
    pmat.mat(:,im) = diff_unc;              im = im + 1;
    pmat.mat(:,im) = tol_unc;               im = im + 1;
    pmat.mat(:,im) = norm_v;                im = im + 1;
    pmat.mat(:,im) = norm_ru;               im = im + 1;
    pmat.mat(:,im) = norm_tu;               im = im + 1;
    pmat.mat(:,im) = chosen_acc;            im = im + 1;
    pmat.mat(:,im) = chosen_unc;            im = im + 1;
    pmat.mat(:,im) = unchosen_acc;          im = im + 1;
    pmat.mat(:,im) = unchosen_unc;          im = im + 1;
    pmat.mat(:,im) = chounch_acc;           im = im + 1;
    pmat.mat(:,im) = chounch_unc;           im = im + 1;
    pmat.mat(:,im) = blocktime;             im = im + 1;
    pmat.mat(:,im) = CI_size;               im = im + 1;
    pmat.mat(:,im) = payoff;                im = im + 1;
    pmat.mat(:,im) = diff_accxblocktime;    im = im + 1;
    pmat.mat(:,im) = diff_uncxblocktime;    im = im + 1;
    pmat.mat(:,im) = tol_uncxblocktime;     im = im + 1;
    pmat.mat(:,im) = diff_accxb_nonorm;     im = im + 1;
    pmat.mat(:,im) = diff_uncxb_nonorm;     im = im + 1;
    pmat.mat(:,im) = tol_uncxb_nonorm;      im = im + 1;
    pmat.mat(:,im) = blockidx;              im = im + 1;
    pmat.mat(:,im) = type;                  im = im + 1;
    pmat.mat(:,im) = half_type;             im = im + 1;
    pmat.mat(:,im) = horizon_type;          im = im + 1;
    pmat.mat(:,im) = cho_plus_uncho_acc;    im = im + 1;
    pmat.mat(:,im) = cho_plus_uncho_unc;    im = im + 1;
    pmat.mat(:,im) = chosen_uti;            im = im + 1;
    pmat.mat(:,im) = unchosen_uti;          im = im + 1;
    pmat.mat(:,im) = cho_plus_uncho_uti;    im = im + 1;
    pmat.mat(:,im) = cho_con_uncho_uti;     im = im + 1;
    pmat.mat(:,im) = precent_acc;           im = im + 1;
    pmat.mat(:,im) = precent_unc;           im = im + 1;
    pmat.mat(:,im) = expected_value;        im = im + 1;
    pmat.mat(:,im) = expected_value_type;   im = im + 1;
    pmat.mat(:,im) = expected_unc;          im = im + 1;
    pmat.mat(:,im) = expected_unc_type;     im = im + 1;
    pmat.mat(:,im) = accxb_left;            im = im + 1;
    pmat.mat(:,im) = accxb_right;           im = im + 1;
    pmat.mat(:,im) = uncxb_left;            im = im + 1;
    pmat.mat(:,im) = uncxb_right;           im = im + 1;
    pmat.mat(:,im) = abs_PE;                im = im + 1;
    pmat.mat(:,im) = abs_PExb;              im = im + 1;
    pmat.mat(:,im) = PE;                    im = im + 1;
    pmat.mat(:,im) = AE;                    im = im + 1;
    pmat.mat(:,im) = repetition;            im = im + 1;
    pmat.mat(:,im) = acc_type;              im = im + 1;
    pmat.mat(:,im) = left_option;           im = im + 1;
    pmat.mat(:,im) = right_option;          im = im + 1;
    pmat.mat(:,im) = chosen;                im = im + 1;
    pmat.mat(:,im) = unchosen;              im = im + 1;
    pmat.mat(:,im) = chosen_pe;             im = im + 1;
    pmat.mat(:,im) = unchosen_pe;           im = im + 1;
    pmat.mat(:,im) = left_pe;               im = im + 1;
    pmat.mat(:,im) = right_pe;              im = im + 1; 
    pmat.mat(:,im) = op_pe(:,1);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,2);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,3);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,4);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,5);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,6);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,7);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,8);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,9);            im = im + 1;
    pmat.mat(:,im) = op_pe(:,10);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,11);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,12);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,13);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,14);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,15);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,16);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,17);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,18);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,19);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,20);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,21);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,22);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,23);           im = im + 1;
    pmat.mat(:,im) = op_pe(:,24);           im = im + 1;
    pmat.mat(:,im) = diff_pe;               im = im + 1;
    pmat.mat(:,im) = diff_pexb;             im = im + 1;
    
    pmat.mat(1:90,:) = sortrows(pmat.mat(1:90,:),-27);
    pmat.mat(91:180,:) = sortrows(pmat.mat(91:180,:),-27);
    pmat.mat(1,61:81)  = 3.142;
    pmat.mat(16,61:81)  = 3.142;
    pmat.mat(46,61:81)  = 3.142;
    pmat.mat(91,61:81)  = 3.142;
    pmat.mat(106,61:81)  = 3.142;
    pmat.mat(136,61:81)  = 3.142;
    
    for i = 1:15
        for j = 58:61
            pmat.mat(i,j+26) = mean(pmat.mat(1:i,j));
        end    
    end    
    
    for i = 16:45
        for j = 62:65
            pmat.mat(i,j+26) = mean(pmat.mat(16:i,j));
        end    
    end    
    
    for i = 46:90
        for j = 66:69
            pmat.mat(i,j+26) = mean(pmat.mat(46:i,j));
        end    
    end    
    
    for i = 91:105
        for j = 70:73
            pmat.mat(i,j+26) = mean(pmat.mat(91:i,j));
        end    
    end   
    
    for i = 106:135
        for j = 74:77
            pmat.mat(i,j+26) = mean(pmat.mat(106:i,j));
        end    
    end   
    
    for i = 136:180
        for j = 78:81
            pmat.mat(i,j+26) = mean(pmat.mat(136:i,j));
        end    
    end   
    % g. save
    s.sub{isub}.pmat = pmat;
end


end