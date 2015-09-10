%% Preparation
clear all;

addpath(genpath('.'));
run('toolbox/vlfeat/toolbox/vl_setup.m');
vl_setupnn;
net = load('./preproc/net/imagenet-vgg-f.mat');

%% compute results
%do_idrees_sift('testdict_512_0005', 3);
do_idrees_idrees(50,3);
%% use results
clear all;
name = 'crowd_dictionary256_mesa_distance';
load(strcat(['./preproc/results/' name '.mat']));

global_error_plot(splits, results, 0.05, name);

