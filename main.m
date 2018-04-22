global GDS;
global GDS_Name;
global GLearners;
global GFS;
global GFS_Name;
GDS = {'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','SRBCT'};
GDS_Name = {'Breast','Cancers','DLBCL','GCM','Leukemia1','Leukemia2','Lung','SRBCT'};
GLearners={'discriminant','naivebayes','svm','tree','NMC','ADA'};  
GFS = {'bhattacharyya','entropy','LaplacianScore','roc','Su','ttest','wilcoxon'};
GFS_Name = {'BC','EN','LS','Roc','Su','T-test','Wilcoxon'};

%%ECOC程序开始
addpath(genpath(pwd));
path = 'E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC';

feature_size = 5:5:150;
FS = GFS{4,6,7};
DS = GDS{1,2,3,5,6,7};
Learners = GLearners{1,2,3,4};


for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for dataset_option = 1: size(DS,2) %dataset
            
            for lindex = 1: size(Learners,2) %base learner%
                
                %获取原始数据
                [TD,TL,TTD,TTL] = load_data([genpath,'/data/data_original/'],DS{dataset_option});
                
                %获取特征选择数据
                [FS_TD,FS_TTD] = get_fsdata([genpath,'/data/data_fs/',DS{dataset_option},'/',DS{dataset_option},'_',FS{fs_option},'.mat'],TD,TTD,feature_option);
                disp(['加载数据：',genpath,'/data/data_original/',DS{dataset_option}]);
                
                ECOCpath = [genpath,'/data/data_ECOC/',num2str(feature_option),'/',FS{fs_option},'/',DS{dataset_option},'_',FS{fs_option},'_',num2str(feature_option)];
                load([ECOCpath,'.mat']);
                
                %ECOC 训练
                results = ecoc_process(DS{dataset_option},FS_TD,TL,FS_TTD,TTL,Learners{lindex});
                
                respath = [genpath,'/data/论文结果整理-期刊-pair/new_N3_F3/acc_dcplx_classifier/data_fs_',num2str(feature_option),'/',FS{fs_option}];
                mkdir(respath);
                
                save_mat(respath,Learners{lindex},DS{dataset_option},dcplx,[]);
                
            end %end of learners
            %
        end%end of datanames
        
    end%end of fs_method
    
end %end of fs_size