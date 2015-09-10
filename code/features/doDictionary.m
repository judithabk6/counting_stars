function [ dictionary ] = doDictionary( images, feature, n_cluster, subsample, name, N )
%doDictionary Computes a nearest neighbor dictionary over images
%   images is a cell containing all images
%   feature is a string with the name of the feature to compute
%   n_cluster is the number of cluster for k-means
%   subsample is the number of features to keep from each image
    
    n_image = length(images);
    final = cell(n_image,1);
    final_length = 0;
    path = strcat(['preproc/dictionary/' name '.mat']);
    if ~exist('preproc/dictionary/','dir')
        throw(MException('doDictionary:NoFolder',...
                'could not access folder preproc/dictionary/'));
    end;
    if strcmp(feature, 'CNN')
        net = getNNET(N); %the number corresponds to wanted version !
    end
        
    disp('Computing features on images');
    for i = 1:n_image
        % compute features
        if strcmp(feature, 'SIFT')
            [~, features] = vl_dsift(single(images{i}));
        elseif strcmp(feature, 'CNN')
            features = CNN_one_image(single(images{i}), net);
            u = size(features);
            features = reshape(features, [u(1) * u(2), u(3)]);
            features = features';
        else
            throw(MException('doDictionary:BadFeatureName',...
                strcat([feature ' is not a valid feature name'])));
        end
        n_f = size(features,2);
        to_keep = randperm(n_f);
        to_keep = to_keep(1:floor(n_f*subsample));
        final{i} = features(:,to_keep);
        final_length = final_length + length(to_keep);
    end
    disp(strcat(['TOTAL SIZE ' num2str(final_length)]));
    disp('Flattening images');
    flattened = zeros(size(final{1},1),final_length);
    k = 1;
    for i = 1:n_image
        count = size(final{i},2);
        flattened(:,k:k+count-1) = final{i};
        k = k+count;
    end
    
    disp('Computing clusters');
    dictionary.words = vl_kmeans(flattened, n_cluster, 'verbose', 'algorithm', 'elkan' );
    dictionary.kdtree = vl_kdtreebuild(dictionary.words) ;
    
    disp('saving');
    save(path, 'dictionary');
end

