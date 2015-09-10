function [ results ] = do_lempitsky_sift( dict_name, sigma )
    [images, ~, density] = loadDataSet('cells',sigma);
    load(strcat(['preproc/dictionary/' dict_name '.mat'])); % Dict variable is supposed to be Dict.
    [features, weights, crops] = loadFeatures('cells', 'SIFT', images, sigma, Dict, 1);
    [cropped_densities] = cropDensities(density, crops);

    Nvalues = [1 2 4 8 16 32];
    distance_f = {'mesa_distance' 'counting_distance'};
    Cvalidation = [-0.001, -0.01, -0.1, 0, 0.1, 0.01, 0.001];
    for d=1:length(distance_f)
        for N=Nvalues
            saving_name = ['preproc/results/lempitsky/counting_cells' dict_name '_' num2str(N) '_' distance_f{d} '.mat'];
            if ~exist(saving_name)
                splits = Lemptisky_split( N, images, 5, 100 );
                [results, bestC] = countingStars(splits, cropped_densities, features, weights, sigma, Cvalidation, 0, distance_f{d}, size(Dict,2));
                save(saving_name,'results', 'splits', 'bestC', 'N');
            end
        end
    end

    files = cell(1, length(Nvalues));
    results = cell(2,1);
    for d=1:length(distance_f)
        for i=1:length(Nvalues )
            files{i} = strcat(['preproc/results/lempitsky/counting_cells' dict_name '_' num2str(Nvalues(i)) '_' distance_f{d} '.mat']);
        end
        results{d} = global_error_table_lemp( 0.05, files );
    end;
    save(strcat(['preproc/results/lempitsky_sift_' dict_name '_' sigma '.mat']), 'results')
end
