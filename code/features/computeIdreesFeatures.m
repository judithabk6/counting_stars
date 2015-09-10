function [ featuresFourier, featuresHead, featuresSIFT, trueCount ] = computeIdreesFeatures( images, annMap, binsize, vocabulary)
% Compute features from Idrees papers, given
%   images 1,K cell
% binsize half length of bin to use
% positions : ground truth annotation
% vocabulary vocabulary computed using asig2
% svmmodel svm parameters computed using libsvm
% lambda computed poisson mean parameter (for confidence)
    

K = numel(images);
m = size(vocabulary.words,2);
trueCount = cell(1,K);
features = cell(1,K);
lambda = cell(1,K);
net = getNNET(6);

%Parameters
freq_thres = int8(floor(binsize*0.2));
detthr = - 3;

% Head detection
model = load('head-gen-on-ub-4laeo.mat'); % IJCV'2013
model = model.model;

lambda_mean = zeros(2,m);

parfor k = 1:K
    str = sprintf('Starting features computation on image #%i\n',k);
    disp(str);
    index = 1;
    [n,p] = size(images{k});
    nb_pixels = floor(n/(2*binsize+1)) * floor(p/(2*binsize+1));
    
    featuresFourier{k}= zeros(nb_pixels,9);
    featuresHead{k}= zeros(nb_pixels,5);
    featuresSIFT{k} = zeros(nb_pixels,m+1);
    trueCount{k} = zeros(nb_pixels,1);
    lambda{k} = zeros(2,m);
    
    positive = 0;
    negative = 0;
    
    for i=1+binsize:2*binsize+1:n-binsize
        for j=1+binsize:2*binsize+1:p-binsize
            patch = images{k}(i - binsize: i + binsize, j - binsize: j + binsize);


            % Fourier
            [patch_grad_x,patch_grad_y] = grad(patch);
            patch_grad = double(patch_grad_x + patch_grad_y);
            
            %filtering
            fft_patch_grad = fftshift(fft2(patch_grad));
            filter = zeros(2*binsize+1,2*binsize+1);
            filter(-freq_thres+binsize+1:freq_thres+binsize+1, -freq_thres+binsize+1:freq_thres+binsize+1) = 1;
            patch_grad_reg = abs(ifft2(ifftshift(fft_patch_grad .* filter)));
            bw = patch_grad_reg > imdilate(patch_grad_reg, [1 1 1; 1 0 1; 1 1 1]);
            
%             figure(1)
%             
%             subplot(2,2,1)
%             colormap(gray)
%             imagesc(patch)
%             title('Patch');
%             
%             subplot(2,2,2)
%             imagesc(patch_grad)
%             title('Gradient');
% 
%             subplot(2,2,3)
%             imagesc(patch_grad_reg)
%             title('Filtered Gradient');
%             
%             subplot(2,2,4)
%             imagesc(bw)
%             title('Peaks');
            
            featuresFourier{k}(index,1) = sum(sum(bw));
%             our_cout = sum(sum(bw))
            trueCount{k}(index) = sum(sum(annMap{k}(i - binsize: i + binsize, j - binsize: j + binsize)));
%             true_count = sum(sum(annMap{k}(i - binsize: i + binsize, j - binsize: j + binsize)))
%             z = waitforbuttonpress
            
            patch_grad_reg_lin = reshape(patch_grad_reg,1,(2*binsize+1)*(2*binsize+1));
            patch_diff = abs(patch_grad_reg-patch_grad);
            patch_diff_lin = reshape(patch_diff,1,(2*binsize+1)*(2*binsize+1));
            
            featuresFourier{k}(index,2) = entropy(double(patch_grad_reg));
            featuresFourier{k}(index,3) = mean(patch_grad_reg_lin);
            featuresFourier{k}(index,4) = var(patch_grad_reg_lin);
            featuresFourier{k}(index,5) = kurtosis(patch_grad_reg_lin);
            if isnan(featuresFourier{k}(index,5))
                featuresFourier{k}(index,5) = 0;
            end

            featuresFourier{k}(index,6) = entropy(double(patch_diff));
            featuresFourier{k}(index,7) = mean(patch_diff_lin);
            featuresFourier{k}(index,8) = var(patch_diff_lin);
            featuresFourier{k}(index,9) = kurtosis(patch_diff_lin);
            if isnan(featuresFourier{k}(index,9))
                featuresFourier{k}(index,9) = 0;
            end
            
            
            % Head detection cf laeohead_v2/_demoheaddet.m
            dets = imgdetect(patch, model, detthr);
            top = nms(dets, 0.5); 
            dets = dets(top,:);
            featuresHead{k}(index,1) = size(dets,1); %number of detection
            featuresHead{k}(index,2) = mean(dets(:,5));
            featuresHead{k}(index,3) = mean(dets(:,6));
            featuresHead{k}(index,4) = var(dets(:,5));
            featuresHead{k}(index,5) = var(dets(:,6));

            %SIFT
            [d] = CNN_one_image(single(patch),net, vocabulary);
            hist = histc(d,1:m);

            freq = hist / (((2*binsize+1))^2);
            if sum(hist) ~= 0
                hist = hist / sum(hist);
            end
            % TODO decide wether to use a SIFT specific SVR or use a
            % eps-SVR on global features
            featuresSIFT{k}(index,2:1+m) = hist;
            
            % Confidence
            if trueCount{k}(index) == 0
                negative = negative + 1;
                lambda{k}(2,:) = lambda{k}(2,:) + freq;
            else
                lambda{k}(1,:) = lambda{k}(1,:) + freq;
                positive = positive +1;
            end
            
            index = index +1;
        end
    end
    lambda{k} = lambda{k} + 1/(100*(2*binsize+1)^2);
    positive = positive + 1;
    negative = negative + 1;
    lambda{k}(1,:) = lambda{k}(1,:) / positive;  
    lambda{k}(2,:) = lambda{k}(2,:) / negative;
    lambda_mean = lambda_mean + lambda{k}/K;
end

disp('Post-processing : computing confidence')

lambda = lambda_mean;

parfor k = 1:K
    index = 1;
    [n,p] = size(images{k});
    for i=1+binsize:2*binsize+1:n-binsize
        for j=1+binsize:2*binsize+1:p-binsize
            hist = featuresSIFT{k}(index,2:1+m);
            featuresSIFT{k}(index,1) = sum(lambda(2,:) - lambda(1,:) + hist .* (log(lambda(1,:))-log(lambda(2,:)))); % confidence
            index = index +1;
        end
    end
end

end

