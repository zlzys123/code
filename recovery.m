% test parameter recovery capabilities of model
% see https://psyarxiv.com/46mbn/

clear all;

niters = 1000;

data = load_data;

tbl = data2table(data,1,1); % standardize, exclude timeouts (behavior)
V = tbl.V;
RU = tbl.RU;
TU = tbl.TU;
blocktime = tbl.blocktime;
formula = 'C ~ -1 + V + RU + TU + blocktime'; % single subject
w_orig = [];
w_rec = [];

for iter = 1:niters
    w = mvnrnd([0 0 0 0], 10 * eye(4));
    %w = exprnd([10 10 10]);
    disp(w);

    DV = w(1) * V + w(2) * RU + w(3) * TU + w(4) * blocktime;
    pred = normcdf(DV); % manual prediction

    C = binornd(1, pred);
    tbl.C = C;

    try
        results_VTURUb = fitglme(tbl,formula,'Distribution','Binomial','Link','Probit','FitMethod','Laplace', 'CovariancePattern','diagonal');

        w_orig = [w_orig; w];
        [w, names] = fixedEffects(results_VTURUb);
        w_rec = [w_rec; w(2) w(1) w(3) w(4)];
    catch e
        disp('got an error while fitting...');
        disp(e);
        % TODO might introduce correlations between parameters
    end
end

save recovery_mvnrnd.mat
