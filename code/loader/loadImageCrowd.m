function [ I, P, F, Ann ] = loadImageCrowd( number,dataset, sigma )
%LOADIMAGEANN Given a file number, load image I and
%compute density estimate based on annotation.
%   filename Name of the image file to be loaded
%   sigma size of the Gaussian regularizing kernel
%   RETURN
%   I image [p, q]
%   P annotation vector [nb_annotation 2]
%   F density vector (based on P regularization)
    I = imread(sprintf('data/%s/%i.jpg',dataset,number));
    [p, q] = size(I);
    load(sprintf('data/%s/%i_ann.mat',dataset,number), 'annPoints');
    P = uint32(ceil(annPoints));
    c = size(P,1);
    Ann = zeros(p,q);
    discarded = 0;
    for i=1:c
        if (P(i,2)<=0 || P(i,1)<=0)
            discarded = discarded + 1;
            continue
        end
        Ann(P(i,2),P(i,1)) = 1;
    end
    F = imfilter(Ann, fspecial('gaussian', sigma*6, sigma));
    scale = 1024/max(size(F));
    if scale<1
        I = imresize(I, scale);
        F = imresize(F, scale);
    end
%     F = zeros(p,q);
%     x = repmat(transpose((1:p)),1,q);
%     y = repmat((1:q),p,1);
%     for i=1:c
%         F = F + exp(- 1. / (2*sigma^2) * ((x-P(i,2)).^2+(y-P(i,1)).^2));
%     end
end