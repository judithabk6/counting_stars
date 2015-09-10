%% Preparation
clear all;

addpath(genpath('.'));
run('toolbox/vlfeat/toolbox/vl_setup.m');
vl_setupnn;
%net = load('./preproc/net/imagenet-vgg-f.mat');
sigma=4;
n_clust = [512, 1024]
%%
for i=1:5
    for j=1:2
        n_c = n_clust(j);
        name = ['crowd_net' num2str(i) '_' num2str(n_c) '_sub_001'];
        [images, ~, density] = loadDataSet('crowd',sigma);
        [ dictionary ] = doDictionary( images, 'CNN', n_c, 0.01, name, i );
        clearvars images density;
        features_path = strcat(['preproc/crowd/CNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        [features,weights, crops] = computeCNNFeatures('crowd', dictionary, i, sigma);
        save(features_path,'features', 'weights', 'crops');
        clearvars dictionary features weights crops;
    end
end
     
%%
[images, ~, density] = loadDataSet('crowd',sigma);
for i=1:6
    for j=1:2
        n_c = n_clust(j);
        splits = Kfold(5, images);
        features_path = strcat(['preproc/crowd/CNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        load(features_path);
        [cropped_densities] = cropDensities(density, crops);
        [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, [], 0.01, 'mesa_distance', n_c);
        results_path = strcat(['preproc/crowd/biscounting_resultsCNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        save(results_path,'results', 'splits');
        clearvars features weights crops results;
    end
end

%%

for i=1:6
    for j=1:2
        n_c = n_clust(j);
        close all;
        results_path = strcat(['preproc/crowd/biscounting_resultsCNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        load(results_path);
        global_error_plot( splits, results, 0.05,  ['biscounting_resultsCNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c)]);
        clearvars results splits;
        close all;
    end
end
        
%%
load('preproc/crowd/biscounting_resultsCNN6_4_nclust512.mat');
[images, ~, density] = loadDataSet('crowd',sigma);
showInterestingDensities(results, splits, images)

%%
n_clust = [256, 512]
for i=1:6
    for j=1:2
        n_c = n_clust(j);
        name = ['cell_net' num2str(i) '_' num2str(n_c) '_sub_001'];
        [images, ~, density] = loadDataSet('cells',sigma);
        [ dictionary ] = doDictionary( images, 'CNN', n_c, 0.01, name, i );
        clearvars images density;
        features_path = strcat(['preproc/cells/CNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        [features,weights, crops] = computeCNNFeatures('cells', dictionary, i, sigma);
        save(features_path,'features', 'weights', 'crops');
        clearvars dictionary features weights crops;
    end
end
   
[images, ~, density] = loadDataSet('cells',sigma);
for i=1:6
    for j=1:2
        n_c = n_clust(j);
        splits = Kfold(5, images);
        features_path = strcat(['preproc/cells/CNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        load(features_path);
        [cropped_densities] = cropDensities(density, crops);
        [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, [], 0.01, 'mesa_distance', n_c);
        results_path = strcat(['preproc/cells/biscounting_resultsCNN' num2str(i) '_' num2str(sigma) '_nclust' num2str(n_c) '.mat']);
        save(results_path,'results', 'splits');
        clearvars features weights crops results;
    end
end