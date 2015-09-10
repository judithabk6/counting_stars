%% Preparation
clear;
run('toolbox/vlfeat/toolbox/vl_setup.m')
sigma=3;

%% load dataset
[images, positions, densities] = loadDataSet('cells',sigma);
%% compute features
[features, weights, crops] = loadFeatures('cells', 'SIFT', images, sigma);

Nvalues = [1];

for i=1:length(Nvalues)                                                                                         
    N = Nvalues(i);                                                                                                                                                                                                 
    splits = Lemptisky_split( N, images, 5, 100 );
    results = linearRidgeRegression(splits, densities, features);
    saving_name = ['preproc/counting_cells-linear-ridge-regression' num2str(N) '.mat'];
    save(saving_name,'results', 'splits', 'N');
end
