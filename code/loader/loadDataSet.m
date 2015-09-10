function [ I, P, F, Ann ] = loadDataSet(dataset, sigma)
%LOADDATA1 Load data from data1
%   dataset : name of the dataset
%   sigma size of the Gaussian regularizing kernel
%   RETURN
%   I image [p, q]
%   P annotation vector [nb_annotation 2]
%   F density vector (based on P regularization)

    dataset_path = strcat(['preproc/' dataset '/data_' num2str(sigma) '.mat']);
    if exist(dataset_path,'file')
        load(dataset_path);
    else
        n = max(numel(dir(['data/', dataset, '/*.jpg'])), ...
        numel(dir(['data/', dataset, '/*cell.png'])));
        if n==0
            error('empty dataset !')
        end
        I = cell(1,n);
        P = cell(1,n);
        F = cell(1,n);
        Ann = cell(1,n);
        disp('loading images');
        for i=1:n
            if strcmp(dataset,'crowd')
                [ I{i}, P{i}, F{i}, Ann{i} ] = loadImageCrowd( i, dataset, sigma );
            elseif strcmp(dataset,'crowd_big')
                [ I{i}, P{i}, F{i}, Ann{i} ] = loadImageCrowd( i, dataset, sigma );
            elseif strcmp(dataset,'cells')
                [ I{i}, P{i}, F{i}, Ann{i} ] = loadImageCell( i, sigma );
            else
                error('unknown dataset !')
            end
        end
        disp('saving');
        save(dataset_path,'I', 'P', 'F', 'Ann');
    end
end

