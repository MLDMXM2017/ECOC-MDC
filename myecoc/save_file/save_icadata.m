%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 保存ica变换后的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_icadata(genpath,order)
    filename=[genpath,'/data_csv/'];
    respath = [genpath,'/data_ica_',num2str(order)];
    mkdir(respath);
    datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'};     
    
    for i=1:size(datanames,2)
         tndata_fn=[filename,datanames{i},'_train_data.csv'];
         tnlabel_fn=[filename,datanames{i},'_train_label.csv'];
         ttdata_fn=[filename,datanames{i},'_test_data.csv'];
         ttlabel_fn=[filename,datanames{i},'_test_label.csv'];     
         
         [data_train,data_train_label,data_test,data_test_label]=read_data(tndata_fn,tnlabel_fn,ttdata_fn,ttlabel_fn);
         [td,dl,testdata,data_test_label]=get_icadata(data_train,data_train_label,data_test,data_test_label);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% 保留原始data
%          td =  data_train';
%          dl = data_train_label;
%          testdata = data_test';
%          data_test_label = data_test_label;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
         
         dtype={'traindata','trainlabel','testdata','testlabel'};
         dname={'td','dl','testdata','data_test_label'};         
         for j=1:size(dtype,2)
            matname=[respath,'/',datanames{i},'_',dtype{j},'.mat'];
            save(matname,dname{j});
         end         
    end    
end

