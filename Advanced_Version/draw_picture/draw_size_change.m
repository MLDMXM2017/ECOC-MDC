%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the line hist chart of accuracy with change of features.

%##########################################################################

function draw_size_change()
DS ={'Breast'};
Learners={'svm'};
FS = {'roc','ttest','wilcoxon'};

lengend_names = {'F1','F2','F3','N2','N3','N4','L3','C1','CF','OVO','DR','OVA','Ordinal','SR','DECOC','ECOCONE','Forest'};
%四种对比算法
ecoc_3 = [15,16,17];
ecoc_4 = [13,15,16,17];
ecoc_6 = [10,12,13,15,16,17];

ecocs = {};
%四种对比算法
ecocs{1} = [1,2,3,ecoc_4];%F1-F3
ecocs{2} = [4,5,ecoc_4];%N2,N3
ecocs{3} = [6,7,ecoc_4];%N4,L3
ecocs{4} = [8,ecoc_4];%Cluster

%六种对比算法
ecocs{5} = [1,2,3,ecoc_6];%F1-F3
ecocs{6} = [4,5,ecoc_6];%N2,N3
ecocs{7} = [6,7,ecoc_6];%N4,L3
ecocs{8} = [8,ecoc_6];%Cluster

% 其他算法
ecocs{9} = [1,2,3,4,5,8];%全部数据复杂度算法

%三种对比算法
ecocs{10} = [1,2,3,ecoc_3];%F1-F3,DECOC,ECOCONE,Forest
ecocs{11} = [4,5,8,ecoc_3];%N2,N3,Cluster,DECOC,ECOCONE,Forest
ecocs{12} = [6,7,ecoc_3];%N4,L3,Cluster,DECOC,ECOCONE,Forest
ecocs{13} = [8,ecoc_3];%Cluster,DECOC,ECOCONE,Forest
ecocs{14} = [1,2,3,4,5,8,ecoc_3];%F1-F3,N2,N3,Cluster

matfile_path = '../../data/data_fs_10--150_pair_newN3-F3/';
pic_res_path = '../../data/pic/acc-fs-size-4/';
mkdir(pic_res_path);

subnames = {'4-F1-F3';'4-N2-N3';'4-N4-L3';'4-Cluster';'6-F1-F3';'6-N2-N3';'6-N4-L3';'6-Cluster';'ALLDC';'3-F1-F3';'3-N2-N3';'3-N4-L3';'3-Cluster';'3-N_C1'};
for ecoc_option = 11
    
    for lindex = 1:size(Learners,2)
        
        % draw a single picture for each dataset
        for dataset_option = 1:size(DS,2)
          
            for fs_option = 1:size(FS,2)
                
                acc = [];
                for i =5:5:150 % feature size
                    
                    %%获取dcplx MAT 文件
                    dcplxmat = [matfile_path,'/data_fs_',num2str(i),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{dataset_option}];
                    icamat= [matfile_path,'/data_fs_',num2str(i),'/',FS{fs_option},'/','ica/ica_',Learners{lindex},'_',DS{dataset_option}];
                    load(dcplxmat);
                    load(icamat);
                    
                    %获取ALL ECOC正确率
                    dcplx = dcplx{size(dcplx,1),2};
                    ica = ica{size(dcplx,1),2};
                    temp = [dcplx ica];
                    for j = 1:size(temp,2)
                        temp{j} = temp{1,j}(1);
                    end
                    acc = [acc;temp];
                    
                end %end of feature size
                
                draw_single_fs_size(cell2mat(acc),ecocs{ecoc_option},lengend_names(ecocs{ecoc_option}));
                
                saveas(gca ,[pic_res_path,'/',FS{fs_option},'_',Learners{lindex},'_',DS{dataset_option},'_',subnames{ecoc_option}],'fig');
                saveas(gca ,[pic_res_path,'/',FS{fs_option},'_',Learners{lindex},'_',DS{dataset_option},'_',subnames{ecoc_option}],'tiff');
                
            end%end of learner
            
        end%end of dataset
        
    end
end
end

function draw_single_fs_size(data,ecoc,legend_value)
font_size = 9;
figure,hold on
set (gcf,'Position',[400,100,350,300]);
x = 5:5:150;
colors =[0,0,0; 0,0,1; 0.3,0,0.5; 0,0.6,1; 0.6,0,0; 0.1,0.1,0.4; 0.84,0.2,0.2; 0.5,0.2,0.9;1,0.1,0.6; 0.2,0.6,0;0.6,0.4,0.2;0.2,0.5,0.2;0,0,0; 0,0,1;0.3,0.3,0.3;0.45,0,0;0,0.45,0];
linestyle = {':','-','--','-','-.','--','-.','-','-.','--',':','-','-','-','-','-.','--'};
marker = {'<','>','^','*','s','d','o','p','h','v','+','*','d','o','p','h','v'};

for i = 1:size(ecoc,2)
    plot(x,data(:,i),'Color',colors(i,:),'LineStyle',linestyle{i},'Marker',marker{i});hold on
end

xlabel('Features','FontSize',font_size);
ylabel('Accuracy','FontSize',font_size);

% if strcmp(legend_value,'wilcoxon') == 1
%     legend(legend_value,'Location','best');
% end
legend(legend_value,'Location','best');
hold off

end


