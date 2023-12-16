%% takes the first 15 trials of each time horizon

blockidx    = get_from_mat(s.sub{isub}.pmat,'blockidx');

for ib = 1:6
    btrials            = find(blockidx==ib);
    bsize              = length(btrials);
    splitidx           = round(bsize/2); 
    trials_first{ib}   = btrials(1:splitidx);
    trials_second{ib}  = btrials(splitidx+1:bsize);
end
% merge same horizons:
horizonidx{1} = sort([trials_first{1} ;trials_first{4}]);% time horizon 45
horizonidx{2} = sort([trials_second{1} ;trials_second{4}]);
horizonidx{3} = sort([trials_first{2} ;trials_first{5}]); % time horizon 30
horizonidx{4} = sort([trials_second{2} ;trials_second{5}]); 
horizonidx{5} = sort([trials_first{3} ;trials_first{6}]); % time horizon 15
horizonidx{6} = sort([trials_second{3} ;trials_second{6}]);