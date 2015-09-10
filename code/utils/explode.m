function [e_d, e_f, e_w] = explode(d, f, w, s)
%EXPLODE Summary of this function goes here
%   Detailed explanation goes here
    e_d = {};
    e_f = {};
    e_w = {};
    index=1;
    for i=1:length(d)
        s_img = size(d{i});
        y=1;
        while y+s(1)-1<=s_img(1)
            x = 1;
            while x+s(2)-1<=s_img(2)
                e_d{1,index} = d{i}(y:y+s(1)-1,x:x+s(2)-1);
                e_f{1,index} = f{i}(y:y+s(1)-1,x:x+s(2)-1);
                e_w{1,index} = w{i}(y:y+s(1)-1,x:x+s(2)-1);
                x = x + s(2);
                index = index+1;
            end
            y = y + s(1);
        end
    end
end

