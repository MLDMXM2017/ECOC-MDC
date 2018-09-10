%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the 3D hist chart of accuracy,data
% comopleity and frequency of occurrence.
% x axis: the mean value of data cplx.
% y axis: the error rate of ECOC algorithm.

%##########################################################################

function draw_error_cplx_fsize_ensemble()
DS ={'Breast','Cancers','DLBCL','Leukemia2','Leukemia3','Lung1'};
Learners={'svm'};  
FS = {'wilcoxon'};
feature_size = 100:5:150;
pic_res_path = '../data/pic/error_cplx_fssize';


colors =[[0,0,1]; [0,1,0]; [1,0,0]; [0,1,1]; [1,0.8,0]; [1,0,1]; [0,0,0]; [0.75,0.75,0.75]; [0,0.5,0.5]; [0.5,0.5,0.4]; [1,0.6,0]; [0.8,0.4,0.4];];
% colors = colormap('vga');

datanames={'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
DC = {'F1','F2','F3','N2','N3','C1'};
marker_size = 7;
dc_names = {'F1','F2','F3','N2','N3','C1'};
fontsize = 9;


%%按照数据集来画图
for fs_option = 1: size(FS,2) %feature selection
    
    for lindex = 1: size(Learners,2) %base learner%
        
        for dc_option = 2
            
            figure,hold on;
            set (gcf,'Position',[400,100,350,300]);
            for  dataset_option = 1: size(DS,2) %dataset
                
                now_color = colors(dataset_option + 1,:);
                data_ensemble_error = [];
                data_ensemble_cplxs = [];
                for feature_option = feature_size %feature size                
                 
                    matname=['../../data/data_fs_10--150_pair_newN3-F3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/dcplx/dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);                    
                    data_ensemble_error = [data_ensemble_error (1 - dcplx{size(dcplx,1),2}{1,dc_option}(1))*100];
                    data_ensemble_cplxs = [data_ensemble_cplxs mean(dcplx{size(dcplx,1),13}{1,dc_option})];
                    
                end
                plot(data_ensemble_cplxs,data_ensemble_error,'o','MarkerFaceColor',now_color,...
                'MarkerEdgeColor',now_color,'MarkerSize',marker_size);
            end    
            legend(datanames,'location','best','FontSize',fontsize);
%             columnlegend(3, datanames, 'location','northwest'); 
            xlabel([dc_names{dc_option},'-Data-Complexity'],'FontSize',fontsize); %x轴
            ylabel('Error-Ratio','FontSize',fontsize); %y轴
            filepath = [pic_res_path,'/',FS{fs_option}];
            mkdir(filepath);
            filename = [FS{fs_option},'_',Learners{lindex},'_',DC{dc_option}];
            disp([filepath,'/',filename]);

            saveas(gca ,[filepath,'/',filename],'fig');
            saveas(gca ,[filepath,'/',filename],'tiff');
        end    
        
    end
end
end

