function [ regularized ] = MSMRF(source,coarse,fine,lambda,cutoff,k,iter)
%MSMRF Computes the multi scale MRF on source
%   coarse is the coarsest level (1 means divide the image in 4)
%   fine is the finest level
%   lambda is the control parameter
%   cutoff is the discontinuity threshold
%   k is the number of labels
%   iter is the number of iterations per level (between 5 and 10 is fine)

    labels = linspace(0,max(source(:)), k);

    [messages] = initMRF(source, coarse-1, k);
    tic;
    for level=coarse:fine
        % init new messages
        [new_messages, block_size, new_image] = initMRF(source, level, k);
        % get messages from previous iteration
        for y=1:size(new_messages{1},1)
            for x=1:size(new_messages{1},2)
                new_messages{2}{y,x} = messages{mod(iter,2)+1}{ceil(y/2),ceil(x/2)};
            end
        end

        % do MRF
        messages = MRF(new_image, new_messages, block_size, labels, iter, lambda, cutoff);
    end;
    disp(strcat(['MS-MRF done in ' num2str(toc) 's']));
    s_img = size(new_messages{1});
    [cost] = getCost(new_image,block_size,s_img,labels,lambda);

    regularized = zeros(s_img);
    for y=1:s_img(1)
        for x=1:s_img(2)
            belief = cost(:,y,x);
            belief = belief + sum(messages{mod(iter,2)+1}{y,x},1)';
            [~, amin] = min(belief);
            regularized(y,x) = labels(amin)*block_size^2;
        end
    end
    
    

end

