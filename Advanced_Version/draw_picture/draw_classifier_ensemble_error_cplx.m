%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the scatte chart of error rate of ECOC
% ensemble algorithm, error rates of classifiers used in the ECOC.
% x axis: the data cplx.
% y axis: the error rate(%).
% square symbol represents the ensemble error rates(%).
% circle symbol represents the classifiers error rates(%).

%##########################################################################

function draw_classifier_ensemble_error_cplx()

Learners={'svm'};  
FS = {'wilcoxon'};
feature_size = 100:5:150;
matfile_path = '../../data/data_fs_10--150_pair_newN3-F3';
pic_res_path = '../../data/pic/error_cplx_fssize/';

sz = 40;
colors =[0,0,0; 0.8,0,0; 0,0,1; 1,0.8,0; 0.6,0.2,0.8;0.5,0.7,0.2;];
DS={'Breast','Cancers','DLBCL','Leukemia2','Leukemia3','Lung1'};
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
                   
                    %º”‘ÿdcplx ˝æ›
                    matname=[matfile_path,'\data_fs_',num2str(feature_option),'\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);
                   
                    inx = size(dcplx,1);
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
               
                xlabel(DC{dc_option}); %x÷·
                ylabel('error-ratio'); %y÷·
                
                filepath = [pic_res_path,FS{fs_option}];
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