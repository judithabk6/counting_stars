function results = linearRidgeRegression(splits, densities, features)
%LINEARRIDGERESGRESSION Summary of this function goes here
%   Detailed explanation goes here
    N = numel(splits)
    results = cell(1,N)
    for k=1:N
        features_train = features(splits{k}.train);
        densities_train = densities(splits{k}.train);
        features_test = features(splits{k}.test);
        densities_test = densities(splits{k}.test);
        n_train = numel(features_train);
        histo = zeros(n_train,256);
        trueCount = zeros(n_train,1);
        for i=1:n_train
            for j=1:256
               histo(i,j) = sum(sum(features_train{i} == j));
            end
        end
        for i=1:n_train
            trueCount(i) = sum(sum(densities_train{i}));
        end
        b = ridge(trueCount,histo,1);
        
        n_test = numel(features_test);
        res = struct('estimatedCount',cell(n_test,1),'trueCount', cell(n_test,1),...
        'estimatedDensity',cell(n_test,1), 'trueDensity',cell(n_test,1)...
        );
        
        histo = zeros(n_test,256);
        for i=1:n_test
            for j=1:256
               histo(i,j) = sum(sum(features_test{i} == j));
            end
        end
        for i =1:n_test
            res(i).trueCount = sum(sum(densities_test{i}));
                res(i).estimatedCount = histo(i,:) * b;
        end
        results{k} = res;
    end
end

