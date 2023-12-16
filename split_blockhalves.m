%% splits trials into blockhalves

blockidx    = get_from_mat(s.sub{isub}.pmat,'blockidx');

bID = 6;half1=[];half2=[];btrials=[];idx_half1=[];idx_half2=[];
for bidx = 1:bID
    btrials  = find(blockidx==bidx);
    bsize    = length(btrials);
    splitidx = round(bsize/2);
    
    half1 = [half1; btrials(1:splitidx)];
    half2 = [half2; btrials(splitidx+1:bsize)];
end
idxhalf{1} = sort(half1);
idxhalf{2} = sort(half2);

