function [res] = display_patch( image, patches, binsize)
    [n,p] = size(image);
    patch_index = 1;

    lines = length(1+binsize:2*binsize+1:n-binsize);
    cols = length(1+binsize:2*binsize+1:p-binsize);
    res = reshape(patches,lines,cols);
end