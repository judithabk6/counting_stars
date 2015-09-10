
%% Preparation
clear all;

addpath(genpath('.'));
run('toolbox/vlfeat/toolbox/vl_setup.m');
vl_setupnn;
%net = load('./preproc/net/imagenet-vgg-f.mat');
sigma=4;

%% load dataset
[images, positions, density] = loadDataSet('cells',sigma);
%% load dictionary
N = 1; % metaparameter to decide the nature of the net
load('preproc/dictionary/cells_net1_512_sub001.mat');

%% compute/load features

[features,weights, crops] = loadFeatures('cells', 'CNN', images, sigma, dictionary, 1);

%% crop densities
[cropped_densities] = cropDensities(density, crops);

%% compute splits
Nvalues = [16];
distance_f = 'mesa_distance';
Cvalidation = 0.1;
for i=1:length(Nvalues)                                                                                         
    N = Nvalues(i);                                                                                                                                                                                                 
    splits = Lemptisky_split( N, images, 5, 100 );
    [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, [], 0.1, distance_f, dictionary.words);
    saving_name = ['preproc/cells/CNNcounting_cells' num2str(N) '-' distance_f '.mat'];
    save(saving_name,'results', 'splits', 'bestC', 'N');
end

%% 
files = cell(1, length(Nvalues));
distance_f = 'mesa_distance'
for i=1:length(Nvalues)
    N = Nvalues(i); 
    files{i} = ['preproc/cells/CNNcounting_cells' num2str(N) '-' distance_f '.mat'];
end
[metrics, summary] = global_error_table_lemp( 0.05, files );

%%
%[images, positions, density] = loadDataSet('crowd',sigma);
%%
N = 1; % metaparameter to decide the nature of the net
load('preproc/dictionary/crowd_net1_512_sub001.mat');
[features,weights, crops] = computeCNNFeatures('crowd', dictionary, N, sigma);
features_path = strcat(['preproc/' 'crowd' '/' 'bCNN' '_' num2str(sigma) '.mat']);
save(features_path,'features', 'weights', 'crops');


features_path = strcat(['preproc/' 'crowd' '/' 'bCNN' '_' num2str(sigma) '.mat']);
load(features_path);
load('preproc/dictionary/crowd_net1_512_sub001.mat');
[images, positions, density] = loadDataSet('crowd',sigma);
[cropped_densities] = cropDensities(density, crops);
splits = Kfold(5, images);


[results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, [], 0.01, 'mesa_distance', dictionary);
%%
save('preproc/processed_crowd_CNN_512_sub001_c001.mat','results', 'splits');