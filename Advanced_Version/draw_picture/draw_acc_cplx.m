%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the line chart of accuracy and sum of
% cplx

%##########################################################################

function draw_acc_cplx()
DS ={'Breast','Cancers','DLBCL','Leukemia2','Leukemia3','Lung1'};
Learners={'naivebayes','svm'};  
FS = {'roc','ttest','wilcoxon'};
DC = {'F1','F2','F3','N2','N3','N4','L3','Cluster'};
linestyle={'p','*','d','s','+','o','x','<'};
pic_res_path = '../data/pic/acc_cplx/';
feature_size = 5:5:50;
mkdir(pic_res_path);

fontsize = 9;
for fs_size = feature_size
    
    for fs_option =  1:size(FS,2)
        
        for ecoc_option = [4,5]
            
            for lindex = 1:size(Learners,2)
                
                clf;%清空figure
                figure
                for data_option = 1:size(DS,2)
                    
                    %加载数据
                    dcplxmat = ['../../data/data_fs_10--150_pair_newN3-F3/data_fs_',num2str(fs_size),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}];
                    disp(['load dcplx path：',num2str(fs_size),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}]);
                    load(dcplxmat);
                    
                    accuracy = dcplx{size(dcplx,1),2}{1,ecoc_option}(1);
                    cplxsum = get_cplx_sum(dcplx,ecoc_option);
                    
                    plot(cplxsum,accuracy,linestyle{data_option},'markersize',8);hold on
                    
                end%end of datanames
                
                xlabel('Cplx Sum','Fontsize',fontsize); %x轴
                ylabel('Accuracy','Fontsize',fontsize); %y轴
                grid on;
                title(DC{ecoc_option});
                legend(DS,'location','best');
                
                hold off
                saveas(gca ,[pic_res_path,DC{ecoc_option},'_',num2str(fs_size),'_',FS{fs_option},'_',Learners{lindex}],'fig');
                saveas(gca ,[pic_res_path,DC{ecoc_option},'_',num2str(fs_size),'_',FS{fs_option},'_',Learners{lindex}],'tiff');
                
            end%end of learners
            
        end%end of ecoc
        
    end%end of fs_method
    
end%end of num

end

function cplxsum = get_cplx_sum(dcplx,ecoc_option)
position = size(dcplx,1);
allcplx = dcplx{position,6}{1,ecoc_option};
cplxsum = 0;
for cplxindex = 1:size(allcplx,2)
    cplxsum = cplxsum + sum(allcplx{1,cplxindex});
    disp(['cplxsum:',num2str(cplxsum)]);
end
end
