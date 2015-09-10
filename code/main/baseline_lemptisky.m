%% Preparation
clear;
run('toolbox/vlfeat/toolbox/vl_setup.m')
sigma=3;

%% load dataset
[images, positions, density] = loadDataSet('cells',sigma);
%% load dictionary
load('preproc/dictionary/dictionary256.mat')
%% compute features
[features, weights, crops] = loadFeatures('cells', 'SIFT', images, sigma, Dict, 1);

%% crop densities
[cropped_densities] = cropDensities(density, crops);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
%% compute splits
Nvalues = [1 2 4 8 16 32];
distance_f = 'mesa_distance';
Cvalidation = [-0.001, -0.01, -0.1, 0, 0.1, 0.01, 0.001];
%%
for i=1:length(Nvalues)                                                                                         
    N = Nvalues(i);                                                                                                                                                                                                 
    splits = Lemptisky_split( N, images, 5, 100 );
    [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, Cvalidation, 0, distance_f, Dict);
    saving_name = ['preproc/counting_cells' num2str(N) '-' distance_f '.mat'];
    save(saving_name,'results', 'splits', 'bestC', 'N');
end


%% get output
files = cell(1, length(Nvalues));
distance_f = 'mesa_distance'
for i=1:length(Nvalues)
    N = Nvalues(i); 
    files{i} = ['preproc/cells/counting_cells' num2str(N) '-' distance_f '.mat'];
end
[metrics, summary] = global_error_table_lemp( 0.05, files );

distance_f = 'counting_distance'
for i=1:length(Nvalues)
    N = Nvalues(i); 
    files{i} = ['preproc/cells/counting_cells' num2str(N) '-' distance_f '.mat'];
end
[metrics_c, summary_c] = global_error_table_lemp( 0.05, files );
