function draw_error_cplx_fsize(genpath,DS,FS,Learners,feature_size)

sz = 40;
colors =[[0,0,1]; [0,1,0]; [1,0,0]; [0,1,1]; [1,0.8,0]; [1,0,1]; [0,0,0]; [0.75,0.75,0.75]; [0,0.5,0.5]; [0.5,0.5,0.4]; [1,0.6,0]; [0.8,0.4,0.4];];

datanames={'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
DC = {'F1','F2','F3','N2','N3','N4','L3','C1'};
marker_size = 5;

feature_option_name = {'100-classifier','100-mean','105-classifier','105-mean','110-classifier',...
    '110-mean','115-classifier','115-mean','120-classifier','120-mean','125-classifier','125-mean',...
    '130-classifier','130-mean','135-classifier','135-mean','140-classifier','140-mean','145-classifier',...
    '145-mean','150-classifier','150-mean'};

for fs_option = 1: size(FS,2) %feature selection
    
    for lindex = 1: size(Learners,2) %base learner%
        
        for dc_option = [2]            
            clf;
            hold on;
            H_classifier = [];
            H_ensemble = [];
            for feature_option = feature_size %feature size
                
                feature_option_inx = find(feature_size == feature_option);
                now_color = colors(feature_option_inx + 1,:);
                data_cplxs = [];
                data_classifier_errors = [];
                
                data_ensemble_error = [];
                data_ensemble_cplxs = [];
                
                for dataset_option = 1: size(DS,2) %dataset
                    global GDS;
                    [~,inx] = ismember(DS{dataset_option},GDS);
                    
                    %加载dcplx数据
                    matname=['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\acc_dcplx_classifier\data_fs_',num2str(feature_option),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);                    
                    
                    data_classifier_errors = [data_classifier_errors dcplx{inx,11}{1,dc_option}*100];                    
                    data_ensemble_error = [data_ensemble_error (1 - dcplx{inx,2}{1,dc_option}(1))*100];
                    
                    if dc_option == 8                    
                        data_ensemble_cplxs = [data_ensemble_cplxs mean(dcplx{inx,13}{1,dc_option-2})/feature_option];
                        data_cplxs = [data_cplxs dcplx{inx,13}{1,dc_option-2}/feature_option];
                    else
                        data_ensemble_cplxs = [data_ensemble_cplxs mean(dcplx{inx,13}{1,dc_option})];
                        data_cplxs = [data_cplxs dcplx{inx,13}{1,dc_option}];
                    end
                    
                end

%                 scatplot1(data_cplxs,data_classifier_errors);
                
                H_classifier(feature_option_inx) = plot(data_cplxs,data_classifier_errors,'o','MarkerFaceColor',now_color,...
                    'MarkerEdgeColor',now_color,'MarkerSize',marker_size);
                
                H_ensemble(feature_option_inx) = plot(data_ensemble_cplxs,data_ensemble_error,'*','MarkerFaceColor',now_color,...
                    'MarkerEdgeColor',now_color,'MarkerSize',marker_size);
            end
       
            lg1 = legend(H_classifier, feature_option_name{[1:2:21]}, 'Location', 'Best');
            ah=axes('position',get(gca,'position'), 'visible','off');
            lg2 = legend(ah, H_ensemble, feature_option_name{[2:2:22]});
            
            xlabel(DC{dc_option}); %x轴
            ylabel('error-ratio'); %y轴
            
            filepath = [genpath,'/data/论文结果整理-期刊-pair\new_N3_F3\error_cplx_fssize\features',FS{fs_option}];
            mkdir(filepath);
            filename = [FS{fs_option},'_',Learners{lindex},'_',DC{dc_option}];
            disp([filepath,'\',filename]);
            
            saveas(gca ,[filepath,'\',filename],'fig');
            saveas(gca ,[filepath,'\',filename],'tiff');
        end
    end
end
end