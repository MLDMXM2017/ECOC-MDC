function get_classifier_acc(genpath,DS,FS,Learners,feature_size)

for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for dataset_option = 1: size(DS,2) %dataset
            
            for lindex = 1: size(Learners,2) %base learner%
                
                %加载train test
                %获取原始数据
                [TD,TL,TTD,TTL] = load_data([genpath,'/data/data_original/'],DS{dataset_option});
                
                %获取特征选择数据
                [FS_TD,FS_TTD] = get_fsdata([genpath,'/data/data_fs/',DS{dataset_option},'/',DS{dataset_option},'_',FS{fs_option},'.mat'],TD,TTD,feature_option);
                disp(['加载数据：',genpath,'/data/data_original/',DS{dataset_option}]);
                
                matname=['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\acc_dcplx_classifier\data_fs_',num2str(feature_size),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                load(matname);
                classifiers_label = dcplx(dataset_option,10);
                ECOCs = dcplx{dataset_option,7};
                Acc = {};
                for ecoc_option = 1:size(ECOCs,2)
                    ecoc = ECOCs{1,ecoc_option};
                    classifier_label = classifiers_label{1,1}{1,ecoc_option};
                    acc = [];
                    for column = 1:size(ecoc,2)
                        non_ingored_classes = find(ecoc(:,column) ~= 0)';
                        
                        test_label = [];
                        samples_inx = [];
                        for class = 1:size(non_ingored_classes,2)
                            inx = find(TTL == non_ingored_classes(class));
                            samples_inx = [samples_inx; inx];
                            inx(:) = ecoc(non_ingored_classes(class),column);
                            test_label = [test_label;inx];
                        end            
                        
                        predicted_label = classifier_label(samples_inx,column);
                        acc =[acc sum(test_label == predicted_label)/size(test_label,1)];
                    end
                    Acc = [Acc acc];
                end
                dcplx{dataset_option,12} = Acc;
                save(matname,'dcplx'); 
            end
        end
    end
end
end