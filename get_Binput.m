function [m] = get_Binput(m,ntr,npred)
% this script transform the raw data into a mat file that is used as Bayesian input
% input: a mat of 24 (predictors) x 45(ntrials)
% Note that the input is determined by the participant's choice

for isub = 1:length(m.ID)
    predmat = NaN(ntr,npred);
    angerr  = abs(rad2deg(get_from_mat(m.sub{isub}.logfile, {'diff_advflo'})));
    choice  = get_from_mat(m.sub{isub}.logfile, {'choice'});
    
    for ip = 1:npred
        curangerr                        = angerr(choice==ip);
        predmat(1:length(curangerr),ip)  = curangerr;
    end
    m.sub{isub}.predmat = predmat;
end
end
