function draw_error_cplx(genpath,DS,FS,Learners,feature_size)

sz = 40;
colors =[0,0,0; 0.8,0,0; 0,0,1; 1,0.8,0; 0.6,0.2,0.8;0.5,0.7,0.2;];
datanames={'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
DC = {'F1','F2','F3','N2','N3','C1'};
marker_size = 5;
for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for lindex = 1: size(Learners,2) %base learner%
            
            Hc = [];
            He = [];
            for dc_option = 1:size([1,2,3,4,5,8],2)
                
                clf;
                hold on;
                for dataset_option = 1: size(DS,2) %dataset                    
                    global GDS;
                    [~,inx] = ismember(DS{dataset_option},GDS);
                    
                    %加载dcplx数据
                    matname=['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\acc_dcplx_classifier\data_fs_',num2str(feature_size),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);
                    
                    classifier_errors = dcplx{inx,11}{1,dc_option}*100;
                    cplxs = dcplx{inx,13}{1,dc_option};
                    plot(cplxs,classifier_errors,'o','MarkerFaceColor',colors(dataset_option,:),...
                         'MarkerEdgeColor',colors(dataset_option,:),'MarkerSize',marker_size);
                    
                    ensemble_error = (1 - dcplx{inx,2}{1,dc_option}(1))*100;
                    cplxs = dcplx{inx,13}{1,dc_option};                    
                    plot(mean(cplxs),ensemble_error,'d','MarkerFaceColor',colors(dataset_option,:),...
                        'MarkerEdgeColor',colors(dataset_option,:),'MarkerSize',marker_size);
                end     
                
                legend('Breast-classifier','Breast-mean','Cancers-classifier',...
                      'Cancers-mean','DLBCL-classifier','DLBCL-mean','Leukemia1-classifier',...
                      'Leukemia1-mean','Leukemia2-classifier','Leukemia2-mean','Lung-classifier',...
                      'Lung-mean','Location','Best');                
               
                xlabel(DC{dc_option}); %x轴
                ylabel('error-ratio'); %y轴
                
                filepath = [genpath,'/data/论文结果整理-期刊-pair\new_N3_F3\error_cplx\',FS{fs_option}];
                mkdir(filepath);
                filename = [num2str(feature_size),'_',FS{fs_option},'_',Learners{lindex},'_',DC{dc_option}];
                disp([filepath,'\',filename]);
                
                saveas(gca ,[filepath,'\',filename],'fig');
                saveas(gca ,[filepath,'\',filename],'tiff');
                
            end
        end
    end
end
end