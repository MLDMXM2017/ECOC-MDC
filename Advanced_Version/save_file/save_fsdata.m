%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 保存feature selection变换后的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_fsdata(genpath)
    filename=[genpath,'/data_csv/'];
    respath = [genpath,'/data_feature_selection'];
    mkdir(respath);
    datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'};     
    fs_options = {'Laplacian','Isomap'};
    
    for i=1:size(datanames,2)
         tndata_fn=[filename,datanames{i},'_train_data.csv'];
         tnlabel_fn=[filename,datanames{i},'_train_label.csv'];
         ttdata_fn=[filename,datanames{i},'_test_data.csv'];
         ttlabel_fn=[filename,datanames{i},'_test_label.csv'];     
         
         [data_train,data_train_label,data_test,data_test_label]=read_data(tndata_fn,tnlabel_fn,ttdata_fn,ttlabel_fn);
         
         dl = data_train_label;
         for k=1:size(fs_options,2)
             [td,testdata]=get_feature_selection(data_train,data_test,fs_options{k});         
             dtype={'traindata','trainlabel','testdata','testlabel'};
             dname={'td','dl','testdata','data_test_label'};         
             for j=1:size(dtype,2)
                matname=[respath,'/',datanames{i},'_',fs_options{k},'_',dtype{j},'.mat'];
                save(matname,dname{j});
             end
         end
         
    end    
end

