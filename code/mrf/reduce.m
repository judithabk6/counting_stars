function [s, reduced] = reduce( source, j)
%reduce sum densities on patches to get a smaller image
%   source is the density image
%   2^j is the final number of patches along smallest axis.
%   reduced contains an array of sum of densities
%   power is the coarsest scale possible

    [mirrored] = expand_image(source);
    power = ceil(log2(min(size(source))));
    s = 2^(power-j);
    
    new_size = (ceil(size(source)/s)*s);
    reduced = mirrored(1:new_size(1), 1:new_size(2));
end

