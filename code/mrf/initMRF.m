function [messages, block_size, image] = initMRF( source, level, k)
%initMRF creates the message passing structure for that level
%   Detailed explanation goes here
    [block_size, image] = reduce(source, level);
    s_img = size(image)/block_size;
    messages = {cell(s_img) cell(s_img)};
    for y=1:size(messages{1},1)
        for x=1:size(messages{1},2)
            messages{1}{y,x} = zeros(4,k);
            messages{2}{y,x} = zeros(4,k);
        end
    end
end

