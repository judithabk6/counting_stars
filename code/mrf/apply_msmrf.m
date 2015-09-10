function [results_with_mrf] = apply_msmrf(results,coarse,fine,lambda,cutoff,precision,n_iter)
%APPLY_MSMRF Summary of this function goes here
%   Detailed explanation goes here
    results_with_mrf = results;
    parfor s=1:length(results)
        for i=1:length(results_with_mrf{s})
            results_with_mrf{s}(i).estimatedDensity = MSMRF(results_with_mrf{s}(i).estimatedDensity,coarse,fine,lambda,cutoff,precision,n_iter);
            results_with_mrf{s}(i).estimatedCount = sum(results_with_mrf{s}(i).estimatedDensity(:));
        end;
    end;

end

