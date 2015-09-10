function [ new_net ] = getNNET( version )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
net = load('imagenet-vgg-f.mat');
switch version
    case 1 % we juste remove max_pooling, and up to conv2
        new_layers = cell(1,4);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        %new_layers{1}.filters = new_layers{1}.filters(:,:,1,:);
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_net = net;
        new_net.layers = new_layers;
    case 2
        new_layers = cell(1,6);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_net = net;
        new_net.layers = new_layers;
    case 3
        new_layers = cell(1,8);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_layers{7} = net.layers{9};
        new_layers{8} = net.layers{10};
        new_net = net;
        new_net.layers = new_layers;
    case 4
        new_layers = cell(1,10);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_layers{7} = net.layers{9};
        new_layers{8} = net.layers{10};
        new_layers{9} = net.layers{11};
        new_layers{10} = net.layers{12};
        new_net = net;
        new_net.layers = new_layers;
    case 5
        new_layers = cell(1,12);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_layers{7} = net.layers{9};
        new_layers{8} = net.layers{10};
        new_layers{9} = net.layers{11};
        new_layers{10} = net.layers{12};
        new_layers{11} = net.layers{13};
        new_layers{12} = net.layers{14};
        new_net = net;
        new_net.layers = new_layers;
    case 6
        new_layers = cell(1,14);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_layers{7} = net.layers{9};
        new_layers{8} = net.layers{10};
        new_layers{9} = net.layers{11};
        new_layers{10} = net.layers{12};
        new_layers{11} = net.layers{13};
        new_layers{12} = net.layers{14};
        new_layers{13} = net.layers{16};
        new_layers{14} = net.layers{17};
        new_net = net;
        new_net.layers = new_layers;
    case 7
        new_layers = cell(1,16);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_layers{7} = net.layers{9};
        new_layers{8} = net.layers{10};
        new_layers{9} = net.layers{11};
        new_layers{10} = net.layers{12};
        new_layers{11} = net.layers{13};
        new_layers{12} = net.layers{14};
        new_layers{13} = net.layers{16};
        new_layers{14} = net.layers{17};
        new_layers{15} = net.layers{18};
        new_layers{16} = net.layers{19};
        new_net = net;
        new_net.layers = new_layers;
    case 8
        new_layers = cell(1,17);
        new_layers{1} = net.layers{1};
        new_layers{1}.stride = [1 1];
        new_layers{2} = net.layers{2};
        new_layers{3} = net.layers{3}; % dismiss of layer 4 (maxpooling)
        new_layers{4} = net.layers{5};
        new_layers{5} = net.layers{6};
        new_layers{6} = net.layers{7};
        new_layers{7} = net.layers{9};
        new_layers{8} = net.layers{10};
        new_layers{9} = net.layers{11};
        new_layers{10} = net.layers{12};
        new_layers{11} = net.layers{13};
        new_layers{12} = net.layers{14};
        new_layers{13} = net.layers{16};
        new_layers{14} = net.layers{17};
        new_layers{15} = net.layers{18};
        new_layers{16} = net.layers{19};
        new_layers{17} = net.layers{20};
        new_net = net;
        new_net.layers = new_layers;
    otherwise
        error('too bad');
end
        
        

end

