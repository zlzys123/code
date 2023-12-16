function [distinfo ] = bayesian_estimates( Dist,pSpace,io)
% caclulates model-estimates of interest: accuracy and uncertainty
% accuracy      = maximum(pdf) 
% uncertainty   = 95% range of pdf's width





%% accuracy estimate

maxDist = max(Dist);
idx     = find(Dist==maxDist);


if size(idx,2) == size(pSpace.sigma,2)  % before first observation
    maxval_acc      = max(pSpace.sigma)/2;
else                                         
    idx         = find(Dist == maxDist);   
    maxval_acc  = pSpace.sigma(idx);
end



%% Parameter: UNCERTAINTY RANGE
% same for EV and MV

cumsum_Dist = cumsum(Dist) ;
up = [];
low= [];


% lower bound:
for ilow = 1: length(cumsum_Dist)
    
    if round(cumsum_Dist(ilow),3) <= 0.0250
    
        low_Dist = Dist(ilow);
        low(ilow,:) = ilow;
        low(low==0)=[];
        lowfinal = max(low); 
         
    end;
end;
a = exist('lowfinal');
if a ==0
    lowfinal = 0;   
end

% upper bound:
for iup = 1:length(cumsum_Dist)
    if round(cumsum_Dist(iup),3) >= 0.9750
        up_Dist  = Dist(iup);
        up(iup,:) = iup;
        up(up==0)=[];
        upfinal = min(up);
    end
end

unc_range = abs(upfinal - lowfinal);

%% save:
distinfo.mat     = [ maxval_acc unc_range];
distinfo.names   = {'max_sigma', 'unc_range'};


end
