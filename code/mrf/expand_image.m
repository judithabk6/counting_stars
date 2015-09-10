function [ mirrored ] = expand_image(image)
%expand_image Used before calling the MRF to smooth out the borders.
%   mirrored is the mirrored image

    ud = flipud(image);
    lr = fliplr(image);
    both = flipud(lr);
    
    mirrored = [image lr;ud both];
end

