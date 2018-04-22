function [reduced_traindata,reduced_testdata] = get_feature_selection(traindata,testdata,fs_option)
%输入参数：训练数据，测试数据，特征选择方法（行是样本，列是基因）
 
    addpath(genpath('E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\feature_select'));   
    tdlen = size(traindata,1);
    data = [traindata;testdata];%合并训练数据和测试数据
    
    switch 'fs_option'        
        case 'Relief'
            [important_data, important_order,  reduced_data, reduced_data_order] = Relief ( data );
            
        case 'Laplacian'
            % 估计本质维数
            no_dims = round(intrinsic_dim(data, 'MLE'));
            disp(['MLE estimate of intrinsic dimensionality: ' num2str(no_dims)]);
            
            %特征选择
            [reduced_data,tdmapping] = compute_mapping(data,'Laplacian',no_dims);        
            
        case 'Isomap'
            % 估计本质维数
            no_dims = round(intrinsic_dim(data, 'MLE'));
            disp(['MLE estimate of intrinsic dimensionality: ' num2str(no_dims)]);
            
            %特征选择
            [reduced_data,tdmapping] = compute_mapping(data,'Isomap',no_dims);            
    end
    
    reduced_traindata = reduced_data(1:tdlen,:);
    reduced_testdata = reduced_data(tdlen+1,:);   
    
end
