function [ cropped_densities ] = cropDensities( density, crops )
%cropDensities crop densities according to crops to match feature size.
%   density is a cell with image densities
%   crops is computed by loadFeatures
    if length(crops)>0
        cropped_densities = cell(length(density),1);
        for i=1:length(density)
            cropped_densities{i} = density{i}(...
                crops{i}(2,1):crops{i}(2,2),...
                crops{i}(1,1):crops{i}(1,2)...
            );
        end
    else
        cropped_densities = density;
    end
end

