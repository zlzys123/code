%% takes each 5 trials of each time horizon

blockidx    = get_from_mat(s.sub{isub}.pmat,'blockidx');

for ib = 1:6
    curidx      = find(blockidx==ib);
    if      ib == 1 ||ib == 4
            trials_1{ib}  = curidx(1:5);
            trials_2{ib}  = curidx(6:10);
            trials_3{ib}  = curidx(11:15);
            trials_4{ib}  = curidx(16:20);
            trials_5{ib}  = curidx(21:25);
            trials_6{ib}  = curidx(26:30);
            trials_7{ib}  = curidx(31:35);
            trials_8{ib}  = curidx(36:40);
            trials_9{ib}  = curidx(41:45);
    elseif ib == 2 ||ib == 5
            trials_1{ib}  = curidx(1:5);
            trials_2{ib}  = curidx(6:10);
            trials_3{ib}  = curidx(11:15);
            trials_4{ib}  = curidx(16:20);
            trials_5{ib}  = curidx(21:25);
            trials_6{ib}  = curidx(26:30);
     else   ib == 3 || ib == 6
            trials_1{ib}  = curidx(1:5);
            trials_2{ib}  = curidx(6:10);
            trials_3{ib}  = curidx(11:15);
     end       
            
end
% merge same horizons:
horizonidx{1} = sort([trials_1{1} ;trials_1{4}]); % time horizon 45
horizonidx{2} = sort([trials_2{1} ;trials_2{4}]);
horizonidx{3} = sort([trials_3{1} ;trials_3{4}]);
horizonidx{4} = sort([trials_4{1} ;trials_4{4}]);
horizonidx{5} = sort([trials_5{1} ;trials_5{4}]);
horizonidx{6} = sort([trials_6{1} ;trials_6{4}]);
horizonidx{7} = sort([trials_7{1} ;trials_7{4}]);
horizonidx{8} = sort([trials_8{1} ;trials_8{4}]);
horizonidx{9} = sort([trials_9{1} ;trials_9{4}]);
horizonidx{10} = sort([trials_1{2} ;trials_1{5}]); % time horizon 30
horizonidx{11} = sort([trials_2{2} ;trials_2{5}]);
horizonidx{12} = sort([trials_3{2} ;trials_3{5}]);
horizonidx{13} = sort([trials_4{2} ;trials_4{5}]);
horizonidx{14} = sort([trials_5{2} ;trials_5{5}]);
horizonidx{15} = sort([trials_6{2} ;trials_6{5}]);
horizonidx{16} = sort([trials_1{3} ;trials_1{6}]); % time horizon 15
horizonidx{17} = sort([trials_2{3} ;trials_2{6}]);
horizonidx{18} = sort([trials_3{3} ;trials_3{6}]);