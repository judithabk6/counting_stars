function [ new_im ] = subdivide( old, binsize )
    new_im = size(old)*binsize;
    for line = 1:size(old,1)
        for col = 1:size(old,2)
            new_im((line-1)*binsize+1:line*binsize, (col-1)*binsize+1:col*binsize) = old(line,col)/binsize^2;
        end
    end
end

