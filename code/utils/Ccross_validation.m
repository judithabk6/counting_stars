function [ metrics ] = Ccross_validation(splits, densities, features, weights, sigma, s, Cvalidation, distance, d)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
n_validation = length(splits{s}.validation);
metrics = zeros(2,length(Cvalidation) ); % first line is mean, second is error bar
distance_funk = str2func(distance);
for c=1:length(Cvalidation)
    regressor = getRegressor(splits, densities, features, weights, s, Cvalidation(c), d);
    out = getTestResults(splits, densities, features, weights, regressor, s, 'validation');
    error = zeros(1, n_validation);
    for i=1:n_validation
        error(i) = distance_funk(out(i));
    end
    metrics(1,c) = mean(error);
    % i don't really know how to get the one with the minimum error,
    % accounting for std too...
    metrics(2,c) = std(error);    
end

end

