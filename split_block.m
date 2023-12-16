%% takes the first 15 trials of each time horizon

blockidx    = get_from_mat(s.sub{isub}.pmat,'blockidx');

for ib = 1:6
    curidx      = find(blockidx==ib);
    trials{ib}  = curidx;
end
% merge same horizons:
block{1} = sort(trials{3}); % time horizon 45
block{2} = sort(trials{2}); % time horizon 30
block{3} = sort(trials{1}); % time horizon 15
block{4} = sort(trials{6}); % time horizon 45
block{5} = sort(trials{5}); % time horizon 30
block{6} = sort(trials{4}); % time horizon 15
