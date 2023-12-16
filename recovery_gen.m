% same as recovery.m but actually generative (i.e. don't take into account subject choices but generate our own)

clear all;

niters = 1000;
addpath('behavglm')
loadname = 'group4_pu(44_45)_result.mat'; 
load(loadname);

formula = 'choice ~ -1 + V + RU + B + TU + acc_B + unc_B + TU_B'; % single subject
w_orig = [];
w_rec = [];

for iter = 1:niters
    w = mvnrnd([0 0 0 0 0 0 0], 1 * eye(7));
    %w = exprnd([10 10 10]);
    disp(w);
    unc_left = get_from_mat(s.sub1.pmat, {'unc_left'}); 
    unc_right = get_from_mat(s.sub1.pmat, {'unc_right'}); 
    TU = sqrt(unc_left.^2 + unc_right.^2);
    choice = get_from_mat(s.sub1.pmat, {'choice'});     
    V = get_from_mat(s.sub1.pmat, 'diff_acc'); 
    RU = get_from_mat(s.sub1.pmat, 'diff_unc'); 
    B = get_from_mat(s.sub1.pmat, 'blocktime'); 
    acc_B = get_from_mat(s.sub1.pmat, 'diff_accxb_nonorm'); 
    unc_B = get_from_mat(s.sub1.pmat, 'diff_uncxb_nonorm'); 
    TU_B = get_from_mat(s.sub1.pmat, 'tol_uncxb_nonorm'); 
    tbl = table(choice,V,RU,B,TU,acc_B,unc_B,TU_B); % run generatively

    try
        results = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace', 'CovariancePattern','diagonal');

        w_orig = [w_orig; w];
        [w, names] = fixedEffects(results);
        w_rec = [w_rec; w(1) w(2) w(3) w(4) w(5) w(6) w(7)];
    catch e
        disp('got an error while fitting...');
        disp(e);
        % TODO might introduce correlations between parameters
    end
end

save recovery_gen_mvnrnd.mat
