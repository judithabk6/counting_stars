function [ results ] = do_idrees_cnn( dict_name, sigma, NetN, feature_name )
    [images, ~, density] = loadDataSet('crowd',sigma);
    load(strcat(['preproc/dictionary/' dict_name '.mat'])); % Dict variable is supposed to be dictionary.
    %[features, weights, crops] = loadFeatures('crowd', 'CNN', images, sigma, dictionary, NetN);
    load(strcat(['preproc/crowd/' feature_name '.mat']));
    [cropped_densities] = cropDensities(density, crops);

    splits = Kfold(5, images);
    [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, [], 0.01, 'mesa_distance', dictionary);
    saving_name = ['preproc/results/idrees/counting_crowds' dict_name '.mat'];
    save(saving_name,'results', 'splits');
    showInterestingDensities(results, splits, images)
    global_error_plot( splits, results, 0.05,  ['counting_crowds' dict_name]);
    
end