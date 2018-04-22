 function [data_train,data_train_label,data_test,data_test_label]=read_data(tndata_fn,tnlabel_fn,ttdata_fn,ttlabel_fn)
% % train data
    data_train=csvread(tndata_fn);
    data_train=data_train(2:size(data_train,1),2:size(data_train,2)); 
    
    data_train=zscore(data_train);%标准化处理
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % train label   
    data_train_label=textread(tnlabel_fn,'%s');
    for i=1:size(data_train_label)
        temp=data_train_label{i};
        temps=regexp(temp,',','split');
        if(size(temps,2)==1)
            data_train_label{i}=temps;
        else
            data_train_label{i}=temps{2};
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % test data   
    data_test=csvread(ttdata_fn); 
    data_test=data_test(2:size(data_test,1),2:size(data_test,2));
    data_test=zscore(data_test);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % test label
    data_test_label=textread(ttlabel_fn,'%s');
    for i=1:size(data_test_label)
        temp=data_test_label{i};
        temps=regexp(temp,',','split');
        data_test_label{i}=temps{2};
    end    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% train的label 转换成数字
    data_train_ln=zeros(size(data_train_label));
    data_train_lu=unique(data_train_label);
    for j=1:size(data_train_label,1)
        str2 = cell2mat(data_train_label(j));
        for i=1:size(data_train_lu,1)
           str1 = cell2mat(data_train_lu(i));         
           if(strcmp(str1,str2)==1)
               data_train_ln(j)=i;
               break;
           end
        end
    end
    data_train_label=data_train_ln;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % test的label 转换成 数字 
    data_test_ln=zeros(size(data_test_label));
    data_test_lu=unique(data_test_label);
    for j=1:size(data_test_label,1)
        str2 = cell2mat(data_test_label(j));
        for i=1:size(data_test_lu,1)
           str1 = cell2mat(data_test_lu(i));   
           if(strcmp(str1,str2)==1)
               data_test_ln(j)=i;
               break;
           end
        end
    end
    data_test_label=data_test_ln;
end 