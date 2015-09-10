function [] = animateMRF( source, coarse, fine, lambdas, cutoff, k, iter ,name)
%ANIMATEMRF Create plots/name, a gif file containing an animation of
%MRF(lambdas)
%   source is the source image
%   coarse is the coarsest level (1 means divide the image in 4)
%   fine is the finest level
%   lambdas are the control parameters
%   cutoff is the discontinuity threshold
%   k is the number of labels
%   iter is the number of iterations per level (between 5 and 10 is fine)

    for l = 1:length(lambdas)
        estimated = MSMRF(source,coarse,fine,lambdas(l),cutoff,k,iter);
        imagesc(estimated);
        M(l) = getframe;
    end

    path=strcat(['plots/' name]);
    for k = 1:length(lambdas)
        im = frame2im(M(k));
        [imind,cm] = rgb2ind(im,256);
        if k==1
            imwrite(imind,cm,path,'gif', 'Loopcount',inf);
        else
            imwrite(imind,cm,path,'gif', 'WriteMode','append');
        end
    end;
end

