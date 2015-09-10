function [ cost ] = getCost( image, block_size, s_img, labels, lambda )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    cost = zeros([length(labels) s_img]);
    for k=1:length(labels)
        for y=1:s_img(1)
            for x=1:s_img(2)
                cropped = image((y-1)*block_size+1:y*block_size, (x-1)*block_size+1:x*block_size);
                cropped = (cropped - labels(k)*ones(size(cropped))).^2;
                cost(k,y,x) = lambda*sum(cropped(:));
            end
        end
    end;
end

