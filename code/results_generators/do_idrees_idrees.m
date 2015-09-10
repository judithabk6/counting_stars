function [ results ] = do_idrees_idrees( binsize, sigma )
    [images, ~, ~, Ann] = loadDataSet('crowd',sigma);
    if exist('preproc/crowd/crowd_net6_512_sub_001.mat','file')
            load('preproc/crowd/crowd_net6_512_sub_001.mat');
    else
            error('no vocab')
            vocabulary = computeVocabularyFromImageList(images);
            save('preproc/crowd/vocabulary.mat','vocabulary');
    end

    if exist('preproc/crowd/idreesfeatures.mat','file')
        load('preproc/crowd/idreesfeatures.mat');
    else  
        [ featuresFourier, featuresHead, featuresSIFT, trueCount ] = computeIdreesFeatures(images, Ann, binsize, dictionary);
        save('preproc/crowd/idreesfeatures_cnn_instead_sift.mat','featuresFourier','featuresHead', 'featuresSIFT', 'trueCount');
    end

    splits = Kfold(5, images);

    features = {featuresFourier, featuresHead, featuresSIFT};

    best_models = cell(3,1);
    best_mse = 1e15*ones(3,1);
    best_normalization = cell(3,2);

    eps = {10.^(-2:0) 10.^(-1:1) 10.^(-3:1)};
    cs = {10.^(-1:3) 10.^(-1:3) 10.^(-4:-1)};

    for f=1:3
        disp(strcat(['Training for feature #' num2str(f)]))
        for e=eps{f}
            for C=cs{f}
                mean_error = 0;
                for s=1:length(splits)
                    split = splits{s};
                    features_train = cat(1,features{f}{split.train});
                    features_test = cat(1,features{f}{split.validation});

                    trueCount_train = cat(1,trueCount{split.train});
                    trueCount_test = cat(1,trueCount{split.validation});                

                    params = ['-s 3 -t 0 -q', ' -c ', num2str(C),...
                              ' -p ', num2str(e)];
                    if f==3
                        features_train = features_train(:,2:end);
                        features_test = features_test(:,2:end);
                    end

                    normalization = get_normalization(features_train);
                    features_train = do_normalization(features_train, normalization);
                    features_test = do_normalization(features_test, normalization);

                    svmmodel = svmtrain(trueCount_train,features_train, params);
                    [estimate,~,~] = svmpredict(trueCount_test, features_test, svmmodel, '-q');

                    mean_error = mean_error + mean((estimate-trueCount_test).^2);
                end
                
                mean_error = mean_error / length(splits);
                if mean_error<best_mse(f)
                    best_mse(f)=mean_error;
                    best_models{f}=svmmodel;
                    best_normalization{f} = normalization;
                end
                disp(strcat(['-- MSE for eps=' num2str(e) ' and C=' num2str(C) ' : ' num2str(mean_error)]))
            end
        end
    end

    best_joint_mse = 1e15;
    best_joint_normalization = cell(2,1);
    eps = 0:4;
    gamma = 2.^(-6:1);
    disp('Training joint svm')
    for e=eps
        for g=gamma
            mean_error = 0;
            for s=1:length(splits)
                split = splits{s};
                trueCount_train = cat(1,trueCount{split.train});
                trueCount_test = cat(1,trueCount{split.validation});

                %get features
                joint_f_train = zeros(length(trueCount_train),4);
                sift_train = cat(1,featuresSIFT{split.train});
                joint_f_train(:,4) = sift_train(:,1);

                joint_f_test = zeros(length(trueCount_test),4);
                sift_test = cat(1,featuresSIFT{split.validation});
                joint_f_test(:,4) = sift_test(:,1);
                
                for f=1:3
                    features_train = cat(1,features{f}{split.train});
                    features_test = cat(1,features{f}{split.validation});
                    if f==3
                        features_train = features_train(:,2:end);
                        features_test = features_test(:,2:end);
                    end

                    normalization = best_normalization{f};
                    features_train = do_normalization(features_train, normalization);
                    features_test = do_normalization(features_test, normalization);
                    
                    [joint_f_train(:,f),~,~] = svmpredict(trueCount_train, features_train, best_models{f}, '-q');
                    [joint_f_test(:,f),~,~] = svmpredict(trueCount_test, features_test, best_models{f}, '-q');

                end;


                C = max(trueCount_train)-min(trueCount_train);
                params = ['-s 3 -t 2 -q ', ' -c ', num2str(C),...
                          ' -g ', num2str(g), ' -p ', num2str(e)];

                normalization = get_normalization(joint_f_train);
                joint_f_train = do_normalization(joint_f_train, normalization);
                joint_f_test = do_normalization(joint_f_test, normalization);

                svmmodel = svmtrain(trueCount_train,joint_f_train, params);
                [estimate,~,~] = svmpredict(trueCount_test, joint_f_test, svmmodel, '-q');

                mean_error = mean_error + mean((estimate-trueCount_test).^2);
            end
            mean_error = mean_error / length(splits);
            if mean_error<best_joint_mse
                best_joint_mse=mean_error;
                best_joint_model=svmmodel;
                best_joint_normalization = normalization;
            end
            disp(strcat(['-- MSE for eps=' num2str(e) ' and gamma=' num2str(g) ' : ' num2str(mean_error)]))
        end
    end

    results = cell(length(splits),1);
    for s=1:length(splits)
        n_test = length(splits{s}.test);
        results{s} = struct('estimatedCount',cell(n_test,1),'trueCount', cell(n_test,1),...
                 'estimatedDensity',cell(n_test,1), 'trueDensity',cell(n_test,1)); 
         for j = 1:n_test
            id_img = splits{s}.test(j);
            image = images{id_img};
            results{s}(j).trueDensity = display_patch(image, trueCount{id_img}, binsize);
            results{s}(j).trueCount = sum(trueCount{id_img});

            joint_features = zeros(length(trueCount{id_img}),4);
            joint_features(:,4) = featuresSIFT{id_img}(:,1);

            for f=1:3
                f_to_use = features{f}{id_img};
                if f==3
                    f_to_use = f_to_use(:,2:end);
                end
                normalization = best_normalization{f};
                f_to_use = do_normalization(f_to_use, normalization);
                [joint_features(:,f),~,~] = svmpredict(trueCount{id_img}, f_to_use , best_models{f}, '-q');
            end
            joint_features = do_normalization(joint_features, best_joint_normalization);
            [patches,~,~] = svmpredict(trueCount{id_img}, joint_features, best_joint_model, '-q');

            results{s}(j).estimatedDensity = display_patch(image, patches, binsize);
            results{s}(j).estimatedCount = sum(results{s}(j).estimatedDensity(:));
        end;
    end
    save(strcat(['preproc/results/CNN_instead_sift_idrees_idrees_' num2str(binsize) '.mat']), 'results', 'binsize', 'splits');
end

