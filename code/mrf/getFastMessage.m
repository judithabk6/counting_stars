function [message] = getFastMessage(heights, labels, cutoff)
%getFatsMessage Computes the message in O(k)
%   heights
%   labels
%   cutoff
    k = length(labels);
    last = 1;
    ids_envelope = [1 zeros(1,k-1)];
    intersections = [-1e15 1e15 zeros(1,k-1)];
    message = zeros(1,k);

    for cur = 2:k
        while true
            id_last = ids_envelope(last);
            s = (heights(cur)-heights(id_last)+labels(cur)^2 - labels(id_last)^2)/(2*(labels(cur)-labels(id_last)));
            if s > intersections(last)
                break;
            end
            last = last -1;
        end
        last = last + 1;
        ids_envelope(last) = cur;
        intersections(last) = s;
        intersections(last+1) = 1e15;
    end
    last = 1;
    for cur = 1:k
        while intersections(last+1)<labels(cur)
            last = last +1;
        end
        id_last = ids_envelope(last);
        message(cur) = (labels(cur)-labels(id_last))^2 + heights(id_last);
    end
    
    message = min(message, min(heights)+cutoff);
end

