function [ words ] = CNN_one_image( im, net, Dict )
%I is an image
% layers is the list of wanted layers
% layers_size contains the size of outputs
% net is the neural net

N = length(net.layers);
if size(im, 3) == 1
    im = single(repmat(im, 1, 1, 3));
end
res = vl_simplenn(net, im, [], [], 'conserveMemory', 'true');
f = res(N+1).x;

u = size(f);
f = reshape(f, [u(1) * u(2), u(3)]);
f = f';
[words, distances] = vl_kdtreequery(Dict.kdtree, single(Dict.words), ...
                                   f, 'MaxComparisons', 10) ;



end

