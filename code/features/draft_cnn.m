etupnn
[images, positions, density] = loadDataSet('crowd',sigma);
im_ = single(images{1});
fil = net.layers{1}.filters;
new_fil = imresize(fil, [3 3]);
new_net = net;
new_net.layers{1}.filters = new_fil;
res = vl_simplenn(net, repmat(im_, 1, 1, 3));
new_res = vl_simplenn(new_net, resize(repmat(im_, 1, 1, 3), 10));
