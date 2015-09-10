function [ new_res ] = subdivide_results( res, binsize )
    new_res = res;
    for i = 1:length(res)
        new_res(i).estimatedDensity = subdivide(res(i).estimatedDensity, binsize);
        new_res(i).trueDensity = subdivide(res(i).trueDensity, binsize);
    end
end

