%新版-3D柱状图
function draw_error_cplx_fsize_3D(genpath,DS,FS,Learners,feature_size)
% datanames={'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
DC = {'F1','F2','F3','N2','N3','C1'};

for fs_option = 1: size(FS,2) %feature selection
    
    for lindex = 1: size(Learners,2) %base learner%
        
        for dc_option = [1]
            
            H_classifier = [];
            H_ensemble = [];
            
            data_classifier_cplxs = [];
            data_classifier_errors = [];
            
            data_ensemble_errors = [];
            data_ensemble_cplxs = [];
            
            data_cplxs = [];
            data_errors = [];
            
            for feature_option = 1:size(feature_size,2) %feature size
                
                features = feature_size(feature_option);
                
                for dataset_option = 1: size(DS,2) %dataset
                    global GDS;
                    [~,inx] = ismember(DS{dataset_option},GDS);
                    
                    %加载dcplx数据
                    matname=['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\acc_dcplx_classifier_nzerovar\four_samples\data_fs_',num2str(features),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);
                    
                    if dc_option == 7
                        data_cplxs = [data_cplxs dcplx{inx,13}{1,dc_option-2}];
                    else
                        data_cplxs = [data_cplxs dcplx{inx,13}{1,dc_option}];
                    end
                    
                    data_errors = [data_errors dcplx{inx,11}{1,dc_option}*100];
                end
            end
            inx = find(data_cplxs == inf);
            data_cplxs(inx) = [];
            data_errors(inx) = [];
            frequence = cal_frequence(data_cplxs,data_errors);
            h = draw_3D_hist(data_cplxs',data_errors',frequence);
            
            filepath = [genpath,'/data/论文结果整理-期刊-pair\new_N3_F3\error_cplx_fssize_3D\single_dataset_features_nzerovar\',FS{fs_option}];
            mkdir(filepath);
            if dc_option == 8
                filename = [FS{fs_option},'_',Learners{lindex},'_',DC{dc_option-2}];
            else
                filename = [FS{fs_option},'_',Learners{lindex},'_',DC{dc_option}];
            end
            
            disp([filepath,'\',filename]);
            
            saveas(gca ,[filepath,'\',filename,'_',DS{dataset_option}],'fig');
            saveas(gca ,[filepath,'\',filename,'_',DS{dataset_option}],'tiff');
        end
    end
end
end

function z = cal_frequence(x,y)
table = [x' y'];
[c] = unique(table,'rows');
z = zeros(size(c,1),1);
for i = 1:size(table,1)
    for j = 1:size(c,1)
        if table(i,:) == c(j,:)
            z(j,1) = z(j,1) + 1;
            break;
        end
    end
end
end