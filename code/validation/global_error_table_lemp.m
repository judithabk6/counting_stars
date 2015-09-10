function [metrics, summary] = global_error_table_lemp( alpha, files)
%makes a table like figure 1 in Lemp article
% files contains the names of files with results...

n = length(files);
load(files{1});
nb_splits = length(splits);
metrics = zeros(nb_splits, n);
for i=1:n
    load(files{i});
    nb_test = length(splits{1}.test);
    table = zeros(nb_splits, nb_test); 
    for j=1:nb_splits
        for k=1:nb_test
            table(j,k) = abs(results{j}(k).estimatedCount - results{j}(k).trueCount);
        end
    end
    mean(table,2)
    metrics(:,i) = mean(table,2);
end
summary = zeros(2,n);
summary(1,:) = mean(metrics);
summary(2,:) = norminv(1-alpha/2) * std(metrics,1) / sqrt(nb_splits);

end

