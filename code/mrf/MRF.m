function [ messages ] = MRF( image, messages, block_size, labels, iter, lambda, cutoff)
%MRF Computes the MRF for a given image, starting with given messages
%   Detailed explanation goes here

    directions = [0 1;1 0;-1 0;0 -1];
    matching_d = [4;3;2;1];
    
    s_img = size(messages{1});
    k = length(labels);
    
    %precompute label costs. O(k*n)
    [cost] = getCost( image, block_size, s_img, labels, lambda);
    
    for i=1:iter
        for y=1:s_img(1)
            for x=1:s_img(2)
                curIndex = [y x];
                heights = cost(:,y,x) + sum(messages{mod(i+1,2)+1}{y,x}',2);
                
                for d=1:4
                    neighbor = curIndex + directions(d,:);
                    if min(neighbor)<1 || min(s_img-neighbor)<0
                        continue
                    end
                    receiving = matching_d(d);
                    this_heights = heights - messages{mod(i+1,2)+1}{y,x}(d, :)';
                    message = getFastMessage(this_heights, labels, cutoff);
                    messages{mod(i,2)+1}{neighbor(1), neighbor(2)}(receiving,:) = message;
                end
            end
        end
    end
end

