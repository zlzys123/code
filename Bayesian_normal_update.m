function [postDist] = Bayesian_normal_update( pSpace, priorDist, observation)
% Bayesian update rule for normal distribution
% updates a prior using the likelihood function for a given single observation
% Model closely matches Jill's PNAS paper (O'Reilly et al., 2013, PNAS) and Jill's Bayes tutorial (on the Posner paradigm)
% INPUT:
%           1) pSpace:      struct with information about pSpace, in particular sigma and mu - space information 
%           2) PriorDist:   probability distribution of prior; dimensions need to be pSpace.mu x pSpace.sigma
%           3) observation: single number indicating observed data
% OUTPUT:
%           1) postDist:    posterior probability distribution, same dimensions as priorDist
%%

% 1) Construct likelihood function
likelihood=NaN(size(pSpace.sigma));

% force a specific format:
priorDist = reshape(priorDist,size(pSpace.sigma));

for imu=1:numel(pSpace.mu),                                                 % find probability of observation give all possible parameter settings in pSpace
    for isi=1:numel(pSpace.sigma),
        likelihood(imu,isi)=normpdf(observation,pSpace.mu(imu),pSpace.sigma(isi)); 
       
    end;
end;


% 2) Bayesian update and normalization of posterior:
post=priorDist.*likelihood;
postDist=post./sum(post(:));  

if round(sum(postDist(:)),4)~=1, disp('ERROR'); keyboard; end;               % probabilities have to add up to one; rounded to fourth decimal


end

