function [ I, P, F, Ann ] = loadImageCell( number, sigma )
%LOADIMAGEANN Given a file number, load image I from cell dataset and
%compute density estimate based on annotation.
%   filename Name of the image file to be loaded
%   sigma size of the Gaussian regularizing kernel
%   RETURN
%   I image [p, q]
%   P annotation vector [nb_annotation 2]
%   F density vector (based on P regularization)

I = imread(['data/cells/' num2str(number, '%03d') 'cell.png']);
% make image in B&W
I = mean(I,3);
[p, q] = size(I);
An = imread(['data/cells/' num2str(number,'%03d') 'dots.png']);
%P = ind2sub([p,q], find(mean(An,3)));
P = zeros(sum(sum(mean(An,3) > 0)),2); %DIIIIRTYYYYYYY
[P(:,1),P(:,2)] = find(mean(An,3));
Ann = double(An(:,:,1))/255;
F = imfilter(Ann, fspecial('gaussian', sigma*6, sigma));
end