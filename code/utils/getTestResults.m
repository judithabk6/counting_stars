function [ res ] = getTestResults(splits, densities, features, weights, regressor, s, type)
%same inputs as counting star
% s is the name of the output
% type is the train set, either train or validation
% regressor is the previosly computed regressor
%   returns a struct object of the same format as before

if strcmp(type, 'validation') && isfield(splits{s}, 'validation')
    considered_data = splits{s}.validation;
elseif strcmp(type, 'test') && isfield(splits{s}, 'test')
    considered_data = splits{s}.test;
else
    error('invalid argument for the type of dataset wanted');
end

n_test = length(considered_data);

testFeatures = features(considered_data);
testWeights = weights(considered_data);
testGtDensities = densities(considered_data);

res = struct('estimatedCount',cell(n_test,1),'trueCount', cell(n_test,1),...
    'estimatedDensity',cell(n_test,1), 'trueDensity',cell(n_test,1)...
    );

for j=1:n_test
    res(j).trueDensity = testGtDensities{j};
    res(j).trueCount = sum(testGtDensities{j}(:));
    %estimating the densities w.r.t. the models
    res(j).estimatedDensity = regressor(testFeatures{j}).*testWeights{j};
    res(j).estimatedCount = sum(res(j).estimatedDensity(:));
end



end

