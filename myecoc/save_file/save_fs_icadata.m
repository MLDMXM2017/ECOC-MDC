%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 保存fs_ica变换后的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_fs_icadata(genpath,order)
    filename=[genpath,'/data_csv/'];
    respath = [genpath,'/data_ica_fs/data_ica_',num2str(order)];
    mkdir(respath);
    
    datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Lung1','SRBCT'};     
    fs_method = {'bhattacharyya','entropy','LaplacianScore','roc','Su','ttest','wilcoxon'};    
    feature_size = 60;
    
    for fs_option = 1:size(fs_method,2)
        
        subrespath = [respath,'/',fs_method{fs_option}];
        mkdir(subrespath);           
        
        for dataset_option=6           
            
             %获取初始数据
             tndata_fn=[filename,datanames{dataset_option},'_train_data.csv'];
             tnlabel_fn=[filename,datanames{dataset_option},'_train_label.csv'];
             ttdata_fn=[filename,datanames{dataset_option},'_test_data.csv'];
             ttlabel_fn=[filename,datanames{dataset_option},'_test_label.csv'];     

             %转换数据格式
             [data_train,data_train_label,data_test,data_test_label]=read_data(tndata_fn,tnlabel_fn,ttdata_fn,ttlabel_fn);
            
             %获取特征选择数据
             [data_train,data_test] = get_fsdata([genpath,'/data_fs/',datanames{dataset_option},'/',datanames{dataset_option},'_',fs_method{fs_option},'.mat'],data_train,data_test,feature_size);
             
             %获取ICA变换数据
             [td,dl,testdata,data_test_label]=get_icadata(data_train,data_train_label,data_test,data_test_label);

             %保存数据
             dtype={'traindata','trainlabel','testdata','testlabel'};
             dname={'td','dl','testdata','data_test_label'};         
             for j=1:size(dtype,2)
                matname=[subrespath,'/',datanames{dataset_option},'_',dtype{j},'.mat'];
                save(matname,dname{j});
             end %end of dtype   
             
        end%end of fs_method
        
    end%end of dataset    
    
end%end of function

 function [fstd,fsttd] = get_fsdata(path,td,ttd,feature_size)
    load(path);
    selected_feature = importance_order(1:feature_size);
    fstd = td(selected_feature,:);
    fsttd = ttd(selected_feature,:);        
end

