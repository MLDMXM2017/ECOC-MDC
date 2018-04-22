
function revise_classifier_error(genpath,DS,FS,Learners,feature_size)

for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for dataset_option = 1: size(DS,2) %dataset
            
            for lindex = 1: size(Learners,2) %base learner%
                
                global GDS;
                [~,inx] = ismember(DS{dataset_option},GDS);
                
                dcplxpath = ['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\acc_dcplx_classifier\data_fs_',num2str(feature_option),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option}];
                load([dcplxpath,'.mat']);
                
                total_predict_label = dcplx{inx,10};
                total_ECOC = dcplx{inx,7};
                total_testlabel = dcplx{inx,4};
                
                total_classifier_error = {};
                total_classifier_right = {};
                for each = 1:size(total_predict_label,2)
                   ecoc = total_ECOC{each};
                   predict_label = total_predict_label{each};
                   classifier_error = get_classifier_error(ecoc,predict_label,total_testlabel);
                   total_classifier_error = [total_classifier_error classifier_error];
                   
                   classifier_right = 1 - classifier_error;
                   total_classifier_right = [total_classifier_right classifier_right];
                end
                
                dcplx{inx,11} = total_classifier_error;
                dcplx{inx,12} = total_classifier_right;
                
                respath = [genpath,'/data/论文结果整理-期刊-pair/new_N3_F3/acc_dcplx_classifier/data_fs_',num2str(feature_option),'/',FS{fs_option}];
                mkdir(respath);
                
                save([dcplxpath,'.mat'],'dcplx');
                
            end %end of learners
            
        end%end of datanames    
        
    end%end of fs_method
    
end %end of fs_size

end


function classifier_error = get_classifier_error(ECOC,predicted_Y,TTL)
classifier_error = [];
for column = 1:size(ECOC,2)
    samples_inx = [];
    true_label = [];
    classes = find(ECOC(:,column) == 1)';%positive classes
    for i = 1:size(classes,2)
        inx = find(TTL == classes(i));
        samples_inx = [samples_inx;inx];
    end
    
    true_label = ones(size(samples_inx,1),1);
    
    classes = find(ECOC(:,column) == -1)';%negative classes
    for i = 1:size(classes,2)
        inx = find(TTL == classes(i));
        samples_inx = [samples_inx;inx];
    end
    
    true_label =[true_label;-ones(size(samples_inx,1)-size(true_label,1),1)];
    
    predict = predicted_Y(samples_inx,column);
    error = sum(predict ~= true_label)/size(samples_inx,1);
    classifier_error = [classifier_error error];
end

end
