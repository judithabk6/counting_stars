function [ results ] = do_idrees_sift( dict_name, sigma )
    [images, ~, density] = loadDataSet('crowd',sigma);
    load(strcat(['preproc/dictionary/' dict_name '.mat'])); % Dict variable is supposed to be Dict.
    [features, weights, crops] = loadFeatures('crowd', 'SIFT', images, sigma, Dict, 1);
    [cropped_densities] = cropDensities(density, crops);

    splits = Kfold(5, images);
    distance_f = 'mesa_distance';
    Cvalidation = [0.1]; %[-0.001, -0.01, -0.1, 0, 0.1, 0.01, 0.001];
    
    [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, Cvalidation, 0, distance_f, Dict);
    saving_name = ['preproc/results/crowd_' dict_name '_' distance_f '.mat'];
    save(saving_name,'results', 'splits', 'bestC');
end