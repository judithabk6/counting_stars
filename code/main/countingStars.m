function [ res, bestC_global ] = countingStars(splits, densities, features, weights, sigma, Cvalidation, C, distance, d)
%COUNTINGSTARS Main function
%   splits
%   densities
%   features Features used for classification
%   weights
%   sigma
%   Cvalidation contains a list of values to cross validate for parameter C
%   if you do not want to cross validate, you just give a value to
%   parameter C
%   distance is the distance to use for cross validation, mesa or counting
res = cell(length(splits),1);
bestC_global = zeros(1,length(splits));
parfor s=1:length(splits)
    if length(Cvalidation)
        metrics = Ccross_validation(splits, densities, features, weights, sigma, s, Cvalidation, distance, d);
        [~, bestC] = min(metrics(1,:)+metrics(2,:));
        bestC = Cvalidation(bestC);
    elseif C
        bestC = C;
    else
        error('problem, C is not cross validated and no value is supplied...');
    end
    regressor = getRegressor(splits, densities, features, weights, s, bestC, d);
    bestC_global(s) = bestC;

    % Compute values on test data
    res{s} = getTestResults(splits, densities, features, weights, regressor, s, 'test');
end
end

