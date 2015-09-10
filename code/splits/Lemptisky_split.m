function [ splits ] = Lemptisky_split( N, data, n, ntest )
%N number of images in the tran and in the validation set
%data: cell array. Used to get number of samples
%n : number of draws (5 in the article)
%ntest : number of images in the test set (100 in the article)
    
    splits = cell(n,1);
    nb_images = length(data);
    for i=1:n
        indices = randsample(nb_images,2*N+ntest);
        splits{i} = struct('train',indices(1:N), 'validation', indices(N+1:2*N),'test',indices(2*N+1:2*N+ntest))
    end;


end

