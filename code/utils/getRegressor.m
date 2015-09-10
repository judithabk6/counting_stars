function [ regressor ] = getRegressor(splits, densities, features, weights, s, C, nFeatures)

    disp(strcat(['Doing split #' num2str(s)]));
    % train regressor
    trainFeatures_n = features(splits{s}.train);
    trainWeights_n = weights(splits{s}.train);
    trainGtDensities_n = densities(splits{s}.train);
    
    s = [min(256,size(densities{1},1)) min(256,size(densities{1},2))];
    [trainGtDensities, trainFeatures, trainWeights] = explode(trainGtDensities_n, trainFeatures_n, trainWeights_n, s);
    
    % not cool
%     nFeatures = size(d,2);
%     if isfield(d, 'words')
%         nFeatures = size(d.words,2);
%     end
    maxIter = 100;
    verbose = false;
    
    weightMap = ones([size(trainFeatures{1},1) size(trainFeatures{1},2)]);

    regressor = LearnToCount(nFeatures, trainFeatures, trainWeights, ...
        weightMap, trainGtDensities, C/length(trainFeatures), maxIter, verbose);
end