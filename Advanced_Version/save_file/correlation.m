%其他相关分析：
% 1.协方差、协方差矩阵
% 2.一元回归、多元回归

FS = {'bhattacharyya','entropy','LaplacianScore','roc','Su','ttest','wilcoxon'};
DS = {'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','SRBCT'};
Learners={'discriminant','naivebayes','svm','tree','NMC','ADA'};

folderpath = 'E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC';
ecocnames = {'F1','F2','F3','N2','N3','N4','L3','Cluster'};
picrespath = [folderpath,'\论文结果整理-期刊-pair\new_N3_F3\ecoc_cplx_accuracy_ttd'];
mkdir(picrespath);

Learners = Learners([2,3]);
dc = {'F1','F2','F3','N2','N3','N4','L3','Cluster'};

fontsize = 8;

for feature_option = 100
    
    for fs_option = [4,6,7]
        
        for ecoc_option = 1:size(ecocnames,2)
            
            for lindex = 1:size(Learners,2)
                
                Csum = [];
                for data_option = [1,2,3,5,6,7]%数据集
                    
                    %获取原始数据
                    [TD,TL,TTD,TTL] = load_data([folderpath,'/data/data_original/'],DS{data_option});
                    
                    %获取特征选择数据
                    [FS_TD,FS_TTD] = get_fsdata([folderpath,'/data/data_fs/',DS{data_option},'/',DS{data_option},'_',FS{fs_option},'.mat'],TD,TTD,feature_option);
                    disp(['加载数据：',folderpath,'/data/data_original/',DS{data_option}]); 
                    
                    %加载复杂度矩阵
                    dcplxmat = [folderpath,'/data/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}];
                    disp([folderpath,'/data/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}]);
                    load([dcplxmat,'.mat']);
                    
                    %得到正确率-矩阵
                    dcplx_accuracy = [];
                    accuracy_matrix = dcplx{data_option,2};
                    for i = [1,2,3,4,5,8]
                        dcplx_accuracy = [dcplx_accuracy accuracy_matrix{1,i}(1)];%得到每个数据复杂度算法的结果
                    end
                    dcplx_ecocs = dcplx{data_option,7};
                    
                    C = [];
                    for dc_option = [1,2,3,4,5,8]%数据复杂度测度
                        
                        %计算ecoc复杂度
                        dcplx_cplx_sum = get_ecoc_cplx_sum(dcplx_ecocs([1,2,3,4,5,8]),FS_TTD,TTL,dc{dc_option});
                        % save([resfilepath,'\',fs_method{fs_option},'_',num2str(num),'_',datanames{data_option},'_',dc{dc_option},'_dcplx_cplx_sum.mat'],'dcplx_cplx_sum');
                        % load([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(num),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                        % disp([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(num),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                        
                       cor = corrcoef(dcplx_accuracy,dcplx_cplx_sum);
                        C = [C cor(1,2)]%计算相关系数-R表示ij元素间的相关性
                        
                    end%end of datanames
                    
                    Csum = [Csum;C];
                    
                end%end of datasets
                fileresname = [picrespath,'/',FS{fs_option},'_',num2str(feature_option),'_',Learners{lindex},'_Accuracy_Correlation_test.csv'];
                csvwrite(fileresname,Csum);
                
            end%end of learners
            
        end%end of ecoc
        
    end%end of fs_method
    
end%end of num
%我查过别的相关性计算方式，有协方差和回归分析，我们现在用的相关性系数，里面也是用到了协方差，所以对于那些数据NAN的，如果觉得不好说明的可以采用协方差分析。