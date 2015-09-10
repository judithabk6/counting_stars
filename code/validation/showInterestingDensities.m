function [ output_args ] = showInterestingDensities(results, splits, images)
%SHOWDENSITIES plot densities for minimal, maximal, mean error
%   INPUT
%   results : K-cell of struc .estimatedCount [nb_images], .trueCount,
%   .estimatedDensity [nb_images_, .trueDensity]
%   splits : K-cell of splits .training, .test : indexes
%   images : image set
K = numel(splits);
n = numel(images);
ind = cell(1,K);
best = zeros(1,K);
worst = zeros(1,K);
biggest = zeros(1,K);
smallest = zeros(1,K);
best_ind = zeros(1,K); 
worst_ind = zeros(1,K);
biggest_ind = zeros(1,K);
smallest_ind = zeros(1,K);

diff = cell(1,K);
for i = 1:K
    test_split = splits{i}.test;
    n = numel(test_split);
    diff{i} = zeros(1,n);
    count{i} = zeros(1,n);
    for j = 1:n
        diff{i}(j) = NaN;
    end
    for j = 1:numel(test_split)
        diff{i}(j) = abs(results{i}(j).trueCount - results{i}(j).estimatedCount);
        count{i}(j) = results{i}(j).trueCount;
    end
    [best(i) best_ind(i)] = min(diff{i});
    [worst(i) worst_ind(i)] = max(diff{i});
    [smallest(i) smallest_ind(i)] = min(count{i});
    [biggest(i) biggest_ind(i)] = max(count{i});
end
[minDiff, argmin] = min(best);
[maxDiff, argmax] = max(worst);
[minCount, argmin_count] = min(smallest);
[maxCount, argmax_count] = max(biggest);
argmin_count = argmin_count(1);
argmax_count = argmax_count(1);

figure;
subplot(1,3,1); 
image(images{splits{argmax}.test(worst_ind(argmax))});
title('Worst case');
subplot(1,3,2); 
imagesc(results{argmax}(worst_ind(argmax)).trueDensity);
title('True density');
subplot(1,3,3); 
imagesc(results{argmax}(worst_ind(argmax)).estimatedDensity);
title('Estimated density');
fprintf('Worst case:\n');
fprintf('True count : %.2f\n', results{argmax}(worst_ind(argmax)).trueCount);
fprintf('Absolute difference : %.2f\n', maxDiff);

figure;
subplot(1,3,1);
image(images{splits{argmin}.test(best_ind(argmin))});
title('Best case');
subplot(1,3,2); 
imagesc(results{argmin}(best_ind(argmin)).trueDensity);
title('True density');
subplot(1,3,3); 
imagesc(results{argmin}(best_ind(argmin)).estimatedDensity);
title('Estimated density');
fprintf('Best case:\n');
fprintf('True count : %.2f\n', results{argmin}(best_ind(argmin)).trueCount);
fprintf('Absolute difference : %.2f\n', minDiff);

figure;
subplot(1,3,1); 
image(images{splits{argmin_count}.test(smallest_ind(argmin_count))});
title('Smallest case');
subplot(1,3,2);
imagesc(results{argmin_count}(smallest_ind(argmin_count)).trueDensity);
title('True density');
subplot(1,3,3);
imagesc(results{argmin_count}(smallest_ind(argmin_count)).estimatedDensity);
title('Estimated density');
fprintf('Smallest case :\n');
fprintf('True count : %.2f\n', minCount);
d = abs(results{argmin_count}(smallest_ind(argmin_count)).trueCount...
- results{argmin_count}(smallest_ind(argmin_count)).estimatedCount);
fprintf('Absolute difference : %.2f\n', d);

figure;
subplot(1,3,1);
image(images{splits{argmax_count}.test(biggest_ind(argmax_count))});
title('Biggest case');
subplot(1,3,2);
imagesc(results{argmax_count}(biggest_ind(argmax_count)).trueDensity);
title('True density');
subplot(1,3,3);
imagesc(results{argmax_count}(biggest_ind(argmax_count)).estimatedDensity);
title('Estimated density');
fprintf('Biggest case :\n')
fprintf('True count : %.2f\n', maxCount);
d = abs(results{argmax_count}(biggest_ind(argmax_count)).trueCount...
- results{argmax_count}(biggest_ind(argmax_count)).estimatedCount);
fprintf('Absolute difference : %.2f\n', d);

% for i=1:numel(indexToShow)
%     figure; title('Image i');
%     subplot(1,3,1); title('Image');
%     image(images{indexToShow(i)});
%     subplot(1,3,2); title('True density');
%     imagesc(results{1}.trueDensity);
%     subplot(1,3,3); title('Estimated density');
%     imagesc(results{1}.trueDensity);
% end

end

