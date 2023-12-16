%% takes the first 15 trials of each time horizon

blockidx    = get_from_mat(s.sub{isub}.pmat,'blockidx');

for ib = 1:6
    curidx      = find(blockidx==ib);
    trials{ib}  = curidx;
end
% merge same horizons:
horizonidx{1} = sort([trials{1} ;trials{4}]); % time horizon 45
horizonidx{2} = sort([trials{2} ;trials{5}]); % time horizon 30
horizonidx{3} = sort([trials{3} ;trials{6}]); % time horizon 15
