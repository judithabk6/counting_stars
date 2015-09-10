function [ best_MAD, params ] = find_best_mrf(results)
lambdas = [0.001 0.003 0.005 0.007 0.01 0.02 0.05 0.07 0.1 0.2 0.5 0.7 1 2 5 7];
cutoffs = [0.001 0.01 0.1 1 5];
n_todo = length(lambdas)*length(cutoffs);

best_MAD = 1e15;
params = cell(2,1);
for lambda=lambdas
    for cutoff=cutoffs
        this_MAD = 0;
        parfor im = 1:length(results)
            mrf = MSMRF(results{im}.estimatedDensity,2,3, lambda, cutoff, 150, 7);
            this_MAD = this_MAD + abs(sum(mrf(:)) - sum(results{im}.estimatedDensity(:)));
        end;
        this_MAD = this_MAD / length(results);
        if this_MAD < best_MAD
            best_MAD = this_MAD
            params = {lambda, cutoff}
        end
    end;
end

