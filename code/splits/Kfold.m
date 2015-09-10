function [ splits ] = Kfold( n, data )
%Kfold Compute train test splits
%   n: number of splits
%   data: cell array. Used to get number of samples
    splits = cell(n,1);
    indices = crossvalind('Kfold', length(data), n);

    for i=1:n
        v = mod(i+1,n)+1;
        train = (indices==i);
        validation = (indices==v);
        test = (indices~=i).*(indices~=v);
        splits{i} = struct('train',find(train),'test',find(test),'validation',find(validation));
    
    end;

end

