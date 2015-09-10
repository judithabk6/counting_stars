function [ means , true_count_mean] = get_means_results( name )
%GET_MEANS_RESULTS Summary of this function goes here
%   Detailed explanation goes here

load(strcat(['preproc/results/final/' name]))
nb_images = 50;
K =  length(splits);
count_im = zeros(1, nb_images);
mean_data = zeros(1,nb_images);
true_count = zeros(1, nb_images);

% get data
for k=1:K
    for i=1:numel(splits{k}.test)
        j = splits{k}.test(i);
        count_im(j) = count_im(j) + 1;
        % online mean / variance computation
        x = results{k}(i).estimatedCount;
        delta = x - mean_data(j);
        mean_data(j) = mean_data(j) + delta/count_im(j);
        true_count(j) = results{k}(i).trueCount;
    end
end

to_keep = count_im~=0;
count_im = count_im(to_keep);
mean_data = mean_data(to_keep);
true_count = true_count(to_keep);
[~,b] = sort(true_count);

true_count = true_count(b);
mean_data = mean_data(b);

bunch = 5;

true_count_mean = zeros(1, nb_images/bunch);
means = zeros(1, nb_images/bunch);

for i=1:length(means)
    true_count_mean(i) = mean(true_count((i-1)*bunch+1:i*bunch));
    means(i) = mean(mean_data((i-1)*bunch+1:i*bunch));
end

end

