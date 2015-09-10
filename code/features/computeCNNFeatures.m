function [features,weights, crops] = computeCNNFeatures(dataset, Dict, N, sigma)
%COMPUTESIFTFeatures returns dense sift features for I
% N is some version of the nnet...
    n = max(numel(dir(['data/', dataset, '/*.jpg'])), ...
        numel(dir(['data/', dataset, '/*cell.png'])));
    features = cell(n,1);
    weights = cell(n,1);
    crops = cell(n,1);
    net = getNNET(N);
    for i=1:n
        disp(['Processing image #' num2str(i) ' (out of ' num2str(n) ')...']);
        if strcmp(dataset,'crowd')
            [ I, P, F, Ann ] = loadImageCrowd( i,dataset, sigma );
        elseif strcmp(dataset,'cells')
            [ I, P, F, Ann ] = loadImageCell( i, sigma );
        else
            error('unknown dataset');
        end
        clearvars P F Ann;
        f = CNN_one_image(single(I), net); %computing the dense sift descriptors centered at each pixel
        %estimating the crop parameters where CNNs were not computed:
        o_size = size(I);
        clearvars I;
        n_size = size(f);
        diff_x = (o_size(1) - n_size(1)) / 2;
        diff_y = (o_size(2) - n_size(2)) / 2;
        if diff_x ~= floor(diff_x)
            diff_x_right = floor(diff_x);
            diff_x = ceil(diff_x);
        else
            diff_x_right = diff_x;
        end
        if diff_y ~= floor(diff_y)
            diff_y_right = floor(diff_y);
            diff_y = ceil(diff_y);
        else
            diff_y_right = diff_y;
        end
        crop = [1+diff_y, o_size(2) - diff_y_right; 1+diff_x o_size(1) - diff_x_right];

        %simple quantized dense SIFT, each image is encoded as MxNx1 numbers of
        %dictionary entries numbers with weight 1 (see the NIPS paper):
        disp('Quantizing SIFTs...');
        u = size(f);
        f = reshape(f, [u(1) * u(2), u(3)]);
        f = f';
        [words, distances] = vl_kdtreequery(Dict.kdtree, single(Dict.words), ...
                                           f, 'MaxComparisons', 10) ;
        clearvars f;
        features{i} = words;
        features{i} = reshape(features{i}, crop(2,2) - crop(2,1)+1, crop(1,2)-crop(1,1)+1);
        

        weights{i} = ones(size(features{i}));
        crops{i} = crop;

    end;
end