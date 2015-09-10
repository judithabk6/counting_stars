function [ normalization ] = get_normalization( feats)
    bias = mean(feats,1);
    scale = std(feats,1);
    scale(scale==0)=1;
    normalization = {bias scale};
end

