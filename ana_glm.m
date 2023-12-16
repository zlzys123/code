% GLM data analysis


%%
close all; clear all;
addpath('bayesian_model');
addpath('behavglm')

%% 0.) load raw data

loadname = 'demo.mat'; 
load(loadname);



%% 1.) get regressors/ apply bayesian
cond={}; % final struct that contains all information
for ib = 1:length(s.cond)  % loops through conditions
m={};m=s.cond{ib};
    ntr=m.ntrials;npred=m.npred;
    
    % a. transform raw data into Bayesian input
    m=get_Binput(m,ntr,npred);
    
    % b. run bayesian model
    m=run_bayesian(m,ntr,npred);
    
    % c. make .mat with regressor of interest (behavioural & neural)
    m=get_regs(m); 
    
    % d. save
    cond{ib}=m;
end


%% 2.) fit GLM

for ib = 1:length(s.cond) % loop through conditions

    % select GLM:
    run = [1 1 1 1];
    % [1 0 0 0] = across all trials     (decision phase)
    % [0 1 0 0] = block halves          (decision phase)
    % [0 0 1 0] = time horizon          (decision phase)
    % [0 0 0 1] = confidence judgment   (confidence phase)
    
    
    % fit GLM:
    m        = cond{ib};
    allval   = behavGLM(m,run);
    
    % save
    cond{ib}.allval = allval;
end
%% 3.) fit glme
for it = 1:length(s.cond) % loop through conditions

    % select glme:
    run = [1 1 1 1 1 1];
    % [1 0 0 0 0] = c~ -1 + v                         (decision phase)
    % [0 1 0 0 0] = c~ -1 + v + tu                    (decision phase)
    % [0 0 1 0 0] = c~ -1 + v + ru                    (decision phase)
    % [0 0 0 1 0] = c~ -1 + v + tu + ru               (decision phase)
    % [0 0 0 0 1] = c~ -1 + v + tu + ru + blocktime   (decision phase)
    
    
    % fit glme:
    m        = cond{it};
    glme_result   = behavglme(m,run);
    
    % save
    cond{it}.glme_result = glme_result;
end


%% 4.) plot GLM
% plots GLMs that are specified in 2)

%plotGLM(cond,run)

%% 5.) end
%clc;
disp('Thanks for your interest in our study.')
disp('If you require more information, email nadescha.trudel@psy.ox.ac.uk')

%keyboard




