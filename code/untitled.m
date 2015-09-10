for k = 1:K
    trueCount_train{k} = cat(1,trueCount{splits{k}.train});
    trueCount_test{k} = cat(1,trueCount{splits{k}.test});
    featuresSIFT_train{k} = cat(1,featuresSIFT{splits{k}.train});
    featuresSIFT_test{k} = cat(1,featuresSIFT{splits{k}.test});
    featuresHead_train{k} = cat(1,featuresHead{splits{k}.train});
    featuresHead_test{k} = cat(1,featuresHead{splits{k}.test});
    featuresFourier_train{k} = cat(1,featuresFourier{splits{k}.train});
    featuresFourier_test{k} = cat(1,featuresFourier{splits{k}.test});
    
    svmmodelSIFT = svmtrain(trueCount_train{k},featuresSIFT_train{k}, '-s 3 -t 0 -p 1 -c 1');
    svmmodelHead = svmtrain(trueCount_train{k},featuresHead_train{k}, '-s 3 -t 0 -p 10 -c 10');
    svmmodelFourier = svmtrain(trueCount_train{k},featuresFourier_train{k}, '-s 3 -t 0 -p 100 -c 10');
    
    estimatedCountSIFT_train{k} = svmpredict(trueCount_train{k}, featuresSIFT_train{k}, svmmodelSIFT, '-q');
    estimatedCountHead_train{k} = svmpredict(trueCount_train{k}, featuresHead_train{k}, svmmodelHead, '-q');
    estimatedCountFourier_train{k} = svmpredict(trueCount_train{k}, featuresSIFT_train{k}, svmmodelFourier, '-q');
    combinedCount_train{k} = [estimatedCountSIFT_train{k},featuresSIFT_train{k}(:,1),estimatedCountHead_train{k},...
    featuresHead_train{k}(:,3),estimatedCountFourier_train{k}];
    
    svmModelCombined = svmtrain(trueCount_train{k},combinedCount_train{k}, ['-s 3 -t 0 -p ' num2str(1) ' -c ' num2str(1)]);
    
    estimatedCountSIFT_test{k} = svmpredict(trueCount_test{k}, featuresSIFT_test{k}, svmmodelSIFT, '-q');
    estimatedCountHead_test{k} = svmpredict(trueCount_test{k}, featuresHead_test{k}, svmmodelHead, '-q');
    estimatedCountFourier_test{k} = svmpredict(trueCount_test{k}, featuresFourier_test{k}, svmmodelFourier, '-q');
    
    combinedCount_test{k} = [estimatedCountSIFT_test{k},featuresSIFT_test{k}(:,1),estimatedCountHead_test{k},...
    featuresHead_test{k}(:,3),estimatedCountFourier_test{k}];
    
    [estimatedCount_test{k},accuracy(k,:),drop] = svmpredict(trueCount_test{k}, combinedCount_test{k}, svmModelCombined, '-q');
end