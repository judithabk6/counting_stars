function [ normalized ] = do_normalization( feats, normalization )
    l = size(feats,1);
    normalized = (feats - repmat(normalization{1},l,1))./repmat(normalization{2},l,1);
end

