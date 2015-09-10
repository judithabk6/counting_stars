function [] = global_error_plot( split, estimation, alpha, filename )
%makes a plot like figure 8 od Idrees article, but with error on total
%counts, mean and std come from the fact that there is some cross
%validation
nb_images = 200;%numel(split{1}.train) + numel(split{1}.test) + numel(split{1}.validation);
K =  length(split);
count_im = zeros(1, nb_images);
mean_data = zeros(1,nb_images);
std_data = zeros(1,nb_images);
true_count = zeros(1, nb_images);

% get data
for k=1:K
    for i=1:numel(split{k}.test)
        j = split{k}.test(i);
        count_im(j) = count_im(j) + 1;
        % online mean / variance computation
        x = estimation{k}(i).estimatedCount;
        delta = x - mean_data(j);
        mean_data(j) = mean_data(j) + delta/count_im(j);
        std_data(j) = std_data(j) + delta*(x-mean_data(j));
        true_count(j) = estimation{k}(i).trueCount;
    end
end

to_keep = count_im~=0;
count_im = count_im(to_keep);
mean_data = mean_data(to_keep);
std_data = sqrt(std_data(to_keep)./count_im);

true_count = true_count(to_keep);
[~,b] = sort(true_count);
% compute bars (mean, std)
%data_error_bars = norminv(1-alpha/2) * std_data ./ sqrt(count_im);
data_error_bars = std_data;

% AD version
figure(1)
errorbar(mean_data(b),data_error_bars(b) ,'rd')
hold on

plot(mean_data(b), 'kd', 'MarkerFaceColor', 'k')
plot(true_count(b), 'bd', 'MarkerFaceColor', 'b')
v=axis;
axis([0 sum(to_keep) v(3) v(4)]);
saveName = (['plots/fig_', filename]);
saveas(gcf, saveName, 'epsc2');
hold off

% normalized version
figure(2)
%errorbar(mean_data(b)./true_count(b),data_error_bars(b)./true_count(b) ,'rd')
hold on
plot(mean_data(b)./true_count(b), 'kd', 'MarkerFaceColor', 'k')
v=axis;
axis([0 sum(to_keep) v(3) v(4)]);
saveName = (['plots/fig_normalized_', filename]);
saveas(gcf, saveName, 'epsc2');
hold off

%compute mean AD
ad = abs(true_count(b) - mean_data(b));
nad = abs(true_count(b) - mean_data(b))./true_count;

disp(strcat(['AD ' num2str(mean(ad)) ' +/- ' num2str(std(ad))]))
disp(strcat(['NAD ' num2str(mean(nad)) ' +/- ' num2str(std(nad))]))

end

