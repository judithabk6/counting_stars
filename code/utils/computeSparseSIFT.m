function [keypoints, words] = computeSparseSIFT( im, vocabulary )
%COMPUTESPARSESIFT Summary of this function goes here
%   Detailed explanation goes here

[keypoints, descriptors] = computeFeatures(im) ;
words = vl_kdtreequery(vocabulary.kdtree, vocabulary.words, ...
                                   single(descriptors), 'MaxComparisons', 15) ;

