function [s] = run_bayesian (s,ntr,npred )

%% simple Bayesian ideal observer for observing values and inferening sigma of a normal distribution
% Model closely matches Jill's PNAS paper (O'Reilly et al., 2013, PNAS) and Jill's Bayes tutorial (on the Posner paradigm)


% aim: infer beliefs about angular error (= sigma of normal distribution)


% INPUT:
%           1) angular error for each predictor = difference between prediction & true target location
%           note: number of observations dependent on participant choice

% OUTPUT:
%           1) postDist: posterior prob. density function over all possible
%           sigma values
%           2) Bayesian estimates: a) accuracy    = maximum of pdf
%                                  b) uncertainty = 95% range of pdf width

% INCLUDED SCRIPTS:
%           1)  Bayesian_get_paramEst:
%               get model-estimtes of accuracy & uncertainty
%           2) Bayesian_normal_update:
%               Bayesian update: prior x likelihood

disp('running Bayesian Model... ')

%% define space

pSpace.sigma          = 1:140; % space of all possible sigma values
pSpace.mu             = 0;     % the distribution is centered on the target (see Trudel 2020, Figure 2)

% prior: we assume a uniform prior
nall                      =numel(pSpace.mu)*numel(pSpace.sigma);
pSpace.flat_initial_prior =repmat(1/nall,numel(pSpace.mu),numel(pSpace.sigma));




for isub = 1:length(s.ID)   % loop through all subjects
    for ipred = 1:npred      % loop through all predictors
        % input = angular error per predictor
        obs       = s.sub{isub}.predmat(:,ipred);
        obs(isnan(obs(:,1)),:)  = [];
        
        % prepare output mats:
        Prior_acc = NaN(ntr,1);
        Post_acc  = NaN(ntr,1);
        
        Prior_unc = NaN(ntr,1);
        Post_unc  = NaN(ntr,1);
        
        Prior_pdf = [];
        Post_pdf  = [];
        
        
        
        % uniform prior:
        priorDist = pSpace.flat_initial_prior;
        
        
        for io=1:numel(obs) % loop through each observation
            
            % ----------------------------------------------------
            %          Parameter of interest estimate (PRIOR):
            % ----------------------------------------------------
            % gets accuracy and uncertainty estimates;
            % here, before observation is made = prior.
            
            
            distinfo = bayesian_estimates(priorDist, pSpace,io);
            Prior_acc (io,:) = distinfo.mat(1);
            Prior_unc (io,:) = distinfo.mat(2);
            
            
            % ----------------------------------------------------
            %                    Bayesian update:
            % ----------------------------------------------------
            % it will only update the posterior distribution after each
            % observation. Note, it will not give updates on parameters of
            % interest (this is only included in check_Dist script)
            
            [postDist] = Bayesian_normal_update( pSpace, priorDist, obs(io));
            
            % ----------------------------------------------------
            %      Parameter of interest estimate (POSTERIOR):
            % ----------------------------------------------------
            
            % Posterior Belief distribution:
            
            [distinfo] =  bayesian_estimates(postDist, pSpace,io);
            
            
            % save information:
            Post_acc (io,:) = distinfo.mat(1);
            Post_unc (io,:) = distinfo.mat(2);
            
            % ----------------------------------------------------
            %      POSTERIOR(t) = PRIOR(t+1)
            % ----------------------------------------------------
            
            priorDist=postDist;
            
            Prior_pdf(:,io) = priorDist;
            Post_pdf(:,io)   = postDist;
            
            
        end;
        
        
        
        
        %% Output        
        
        % --- check nan's: if a predictor has not been chosen, then the
        % value is NaN, however the first value is the prior belief before
        % the observation -> every predictor should have this on trial 1
        % indepdent on whether the predictor was selected or not
        
        if isnan(Prior_acc(1))== 1
            uniDist = pSpace.flat_initial_prior;
            defaultvals = bayesian_estimates(uniDist, pSpace);
            Prior_acc(1)=defaultvals.mat(1); Prior_unc(1)=defaultvals.mat(2);
        end
       
        % -- save:
        
        % Maximum value Accuracy:
        % note that we reverse the sign of accuracy such that a higher
        % value means, more accurate
        s.sub{isub}.bayes.presout{isub}.prior.maxval_acc     (:,ipred)     = Prior_acc*-1;
        s.sub{isub}.bayes.presout{isub}.posterior.maxval_acc (:,ipred)     = Post_acc*-1;
        s.sub{isub}.bayes.presout{isub}.comb.maxval_acc      (:,ipred)     = [Prior_acc(1)*-1; Post_acc*-1];
        
        % Uncertainty Range:
        s.sub{isub}.bayes.presout{isub}.prior.unc_range      (:,ipred)     = Prior_unc;
        s.sub{isub}.bayes.presout{isub}.posterior.unc_range  (:,ipred)     = Post_unc;
        s.sub{isub}.bayes.presout{isub}.comb.unc_range       (:,ipred)     = [Prior_unc(1); Post_unc];
        
        % save distribution
        s.sub{isub}.bayes.dist.priordist{ipred}              = Prior_pdf;
        s.sub{isub}.bayes.dist.postdist{ipred}               = Post_pdf;
        
        
        
        
    end
    
end

%% transforms bayesian into a readable mat file for later scripts:
s=transform_bayesian(s,ntr,npred);


end


















