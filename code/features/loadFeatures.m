function [ features, weights, crops ] = loadFeatures( dataset, feature_type, images, sigma, dict, N )
%loadFeatures Loads or computes features for a certain dataset.
%   Dataset : the name of the dataset
%   feature_type : the type of features
%   images : cell containing the loaded images
%   sigma :
%   features : computed features
%   weights : feature weights
%   crops : how to crop densities
%   dict : k-means dictionary
%   N parameter for nnet...
    %% Compute features
    features_path = strcat(['preproc/' dataset '/' feature_type '_' num2str(sigma) '.mat']);
    if exist(features_path,'file')
        load(features_path);
    else
        if strcmp(feature_type,'RF')
            [features] = computeRFFeatures(I);
            weights = [];
            crops = [];
        elseif strcmp(feature_type,'SIFT')
            [features, weights, crops] = computeSIFTFeatures(images, dict);
        elseif strcmp(feature_type,'CNN')
            [features, weights, crops] = computeCNNFeatures(dataset, dict, N, sigma);
        else 
            throw(MException('CS:BadFeatureName',...
                strcat(feature_type, ' is not a valid feature name')...
            ))
        end
        save(features_path,'features', 'weights', 'crops');
    end
    
end

