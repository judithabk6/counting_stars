function [features,weights, crops] = computeSIFTFeatures(I, Dict)
%COMPUTESIFTFeatures returns dense sift features for I
    n = length(I);
    features = cell(n,1);
    weights = cell(n,1);
    crops = cell(n,1);
    parfor i=1:n
        disp(['Processing image #' num2str(i) ' (out of ' num2str(n) ')...']);
 
        [f,d] = vl_dsift(single(I{i})); %computing the dense sift descriptors centered at each pixel
        %estimating the crop parameters where SIFTs were not computed:
        minf = floor(min(f,[],2));
        maxf = floor(max(f,[],2));
        crop = [minf maxf];

        %simple quantized dense SIFT, each image is encoded as MxNx1 numbers of
        %dictionary entries numbers with weight 1 (see the NIPS paper):
        disp('Quantizing SIFTs...');
        features{i} = vl_ikmeanspush(uint8(d),Dict);
        features{i} = reshape(features{i}, crop(2,2) - crop(2,1)+1, crop(1,2)-crop(1,1)+1);

        weights{i} = ones(size(features{i}));
        crops{i} = crop;
    end;
end