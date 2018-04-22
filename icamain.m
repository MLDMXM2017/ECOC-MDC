% fs_method = {'bhattacharyya','entropy','LaplacianScore','roc','Su','ttest','wilcoxon'};
% datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'};
% ECOC：1~3-F 4~5-N 6~7-L 8-cluster 9-CF 10-OVO 11-DR 12-OVA 13-Ordinal 14-SR 15-DECOC 16-ECOCONE 17-Forest-ECOC
% GLearners={'discriminant','naivebayes','svm','tree','NMC','ADA'};

%%程序选择
function icamain(genpath,order,num)
global GDS;
global GDS_Name;
global GLearners;
global GFS;
global GFS_Name;

switch order
    %ICA + ECOC
    case 1
        for i = 1:num
            %save_icadata(genpath,i);
            ica_fun(i,DS,Learners);
        end
        %feature selection + ECOC
    case 2
        fs_fun(genpath,GDS,GFS([7]),GLearners([3]),100);
        %feature selection
    case 3
        fs_fun_decoding(genpath,GDS([1,2,3,5,6,7]),GFS([6,7]),GLearners([3]),100);
        %feature selection
    case 4
        %origin data + feature selection + ica change
        for i = 1:num
            save_fs_icadata(genpath,i);
        end
        
        %feature selection + ICA + ECOC
    case 5
        for i = 1:num
            fs_ica_fun(genpath,i);
        end
        
        %save ICA data
    case 6
        for i = 1:num
            save_ica_fsdata(genpath,i);
        end
        
        %draw feature size figure
    case 7
        draw_size_change(genpath,GDS([2,3,4,5,6,7]),GFS([4,7]),GLearners([3,5]));
        
        %draw accuary_cplx figure
    case 9
        draw_acc_cplx_fun(genpath,GDS([2,3,4,5,6,7]),GFS([4,7]),GLearners([3,5]),150);
        
        %draw time figure
    case 10
        draw_time_fun(genpath);
        
        %draw cplx figure
    case 11
        draw_ecoc_cplx(genpath);
        
        %claculate PD
    case 12
        draw_PD(genpath,GDS([1,2,3,5,6,7]),GFS([4,6,7]),GLearners([2,3]),[100]);
        %calculate correlation
    case 13
        draw_test(genpath,GDS([1,2,3,5,6,7]),GFS([4,6,7]),GLearners([1,2,3,4]),DC([1,2,3,4,5,9]),[100,150]);
        %draw accuracy_fscore_cplx figure
    case 14
        draw_classifier_test(genpath,GDS([1,2,3,5,6,7]),GFS([4,6,7]),GLearners([2,3]),100);
        %save accuracy classifier correlation test
    case 15
        draw_accuracy_fscore(genpath);
    case 16
        get_classifier_acc(genpath,GDS([1,2,3,5,6,7]),GFS([4,6,7]),GLearners([2,3]),100);
    case 17
        draw_error_cplx(genpath,GDS([1,2,3,5,6,7]),GFS([7]),GLearners([3]),100);
    case 18
        draw_error_cplx_fsize(genpath,GDS([1,2,3,5,6,7]),GFS([7]),GLearners([3]),100:5:150);
    case 19
        %datasets
        draw_error_cplx_fsize_ensemble(genpath,GDS([1,2,3,5,6,7]),GFS([7]),GLearners([3]),100:5:150);
    case 20
        draw_error_cplx_fsize_3D(genpath,GDS([6]),GFS([7]),GLearners([3]),[100:5:150]);
    case 21
        revise_classifier_error(genpath,GDS([1,2,3,5,6,7]),GFS([4,6,7]),GLearners([2]),80:5:150);
    case 22
        revise_classifier_F1(genpath,GDS([1,2,5,6,7]),GFS([7]),GLearners([3]),100:5:150);
    case 23
        calculate_class_num(genpath,GDS([1,2,3,5,6,7]));
end

end

function ica_fun(order,DS,Learners)
learnerdata = {};

for dataset_option = 1: size(DS,2)%dataset
    
    for lindex = 1: size(Learners,2) %base learner
        
        %加载数据
        [TD,TL,TTD,TTL] = load_data([pwd,'/data/data_ica_',num2str(order),'/'],DS{dataset_option});
        
        %ECOC 训练
        [dcplx,ica] = ECOC_train(DS{dataset_option},TD,TL,TTD,TTL,Learners{lindex});
        
        %保留正确率等数据
        learnerdata{lindex,dataset_option,1} = dcplx{dataset_option,2} ;
        learnerdata{lindex,dataset_option,2} = ica{dataset_option,2} ;
        
        respath = [pwd,'/data/data_ica_',num2str(order),'/ica_res'];
        mkdir(respath);
        
        %保存数据MAT文件
        dcplxpath = [respath,'/dcplx'];
        mkdir(dcplxpath);
        matname=[dcplxpath,'/dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
        save(matname,'dcplx');
        
        dcplxpath = [respath,'/ica'];
        mkdir(dcplxpath);
        matname=[dcplxpath,'/ica_',Learners{lindex},'_',DS{dataset_option},'.mat'];
        save(matname,'ica');
        
        %保存正确率CSV文件
        save_csv(dcplx,ica,respath,[DS{dataset_option},'_',Learners{lindex}]);
        
    end %end of learners
    
end%end of datanames

%保存数据CSV文件
save_learner(learnerdata,respath,datanames);

end

function [dcplx,ica] = ECOC_train(DName,TD,TL,TTD,TTL,classifier)
%数据复杂度算法
global GDS;
[~,inx] = ismember(DName,GDS);

dcplx={};
%[data_test_label,all_labels,accuaryratio,elapsed,tcplx,tcds,confmat,binary_y,classifier_error,classifier_right,ECOC_cplx] = ica_ecoc(TD,TL,TTD,TTL,'data_cplx',classifier);
%dcplx{inx,1}=DName;%（数据集名称）
%dcplx{inx,2}=accuaryratio;%（正确率（Accuracy，Precision，Recall，Specifity，Fscore））
%dcplx{inx,3}=all_labels;%(训练结果的labels)
%dcplx{inx,4}=data_test_label;%（原始test labels）
%dcplx{inx,5}=elapsed;%（训练时间）
%dcplx{inx,6}=tcplx;%（复杂度变化）
%dcplx{inx,7}=tcds;%（复杂度矩阵）
%dcplx{inx,8}=TD;%（原始训练数据）
%dcplx{inx,9}=confmat;%（混淆矩阵）
%dcplx{inx,10}=binary_y;
%dcplx{inx,11}=classifier_error;
%dcplx{inx,12}=classifier_right;
%dcplx{inx,13}=ECOC_cplx;

%其他的算法 train
ica={};
 [data_test_label,all_labels,accuaryratio,elapsed,~,tcds,confmat]=ica_ecoc(TD,TL,TTD,TTL,'ica',classifier);
 ica{inx,1}=DName;
 ica{inx,2}=accuaryratio;
 ica{inx,3}=all_labels;
 ica{inx,4}=data_test_label;
 ica{inx,5}=elapsed;
 ica{inx,6}={};%（没有复杂度变化）
 ica{inx,7}=tcds;
 ica{inx,8}=TD;
 ica{inx,9}=confmat;
end

function fs_fun(genpath,DS,FS,Learners,feature_size)
global tcds;

learnerdata={};

for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for dataset_option = 1: size(DS,2) %dataset
            
            for lindex = 1: size(Learners,2) %base learner%
                
                %获取原始数据
                [TD,TL,TTD,TTL] = load_data([genpath,'/data/data_original/'],DS{dataset_option});
                
                %获取特征选择数据
                %[FS_TD,FS_TTD] = get_fsdata([genpath,'/data/data_fs/',DS{dataset_option},'/',DS{dataset_option},'_',FS{fs_option},'.mat'],TD,TTD,feature_option);
                %disp(['加载数据：',genpath,'/data/data_original/',DS{dataset_option}]);
                
                %ECOCpath = [genpath,'/data/data_ECOC/',num2str(feature_option),'/',FS{fs_option},'/',DS{dataset_option},'_',FS{fs_option},'_',num2str(feature_option)];
                %load([ECOCpath,'.mat']);
                
                %ECOC 训练
                [~,ica] = ECOC_train(DS{dataset_option},TD,TL,TTD,TTL,Learners{lindex});
                
                %                 load(['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\data_fs_10--150_pair_newN3_newF3\data_fs_100\',FS{fs_option},'\ica\ica_',Learners{lindex},'_',DS{dataset_option}]);
                %                 load(['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\data_fs_10--150_pair_newN3_newF3\data_fs_100\',FS{fs_option},'\dcplx\dcplx_',Learners{lindex},'_',DS{dataset_option}]);
                
                
                %                 %保留正确率等数据
                %                 learnerdata{lindex,dataset_option,1} = dcplx{dataset_option,2} ;
                %                 learnerdata{lindex,dataset_option,2} = ica{dataset_option,2} ;
                
                respath = [genpath,'/data/data_all_feature_backup/data_fs_',num2str(feature_option),'/',FS{fs_option}];
                mkdir(respath);
                
                save_mat(respath,Learners{lindex},DS{dataset_option},[],ica);
                
                %                 %save data as csv in order by acc and cplx
                %                 save_csv(dcplx,ica,respath,[DS{dataset_option},'_',Learners{lindex}]);
                %                 %
                %                     [learnerdata] = get_learners_data([pwd,'./data/data_fs_10--150'],feature_option,FS,fs_option,Learners{lindex},DS{dataset_option},learnerdata);
                %                     respath = [genpath,'/data/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option}];
                
            end %end of learners
            %
        end%end of datanames
        
        %save data as csv in order by learners
        %         save_learner(Learners,learnerdata,respath,DS);
        
    end%end of fs_method
    
end %end of fs_size

end

function fs_fun_decoding(genpath,DS,FS,Learners,feature_size)

decodings = {'HD','ED','LAP','AED','LLB','ELB','LLW','ELW'};

for feature_option = feature_size %feature size
    
    for fs_option = 1: size(FS,2) %feature selection
        
        for dataset_option = 1: size(DS,2) %dataset
            
            for lindex = 1: size(Learners,2) %base learner%
                
                for decoding_option = 1:size(decodings,2) %decoding
                    
                    %获取原始数据
                    [TD,TL,TTD,TTL] = load_data([genpath,'/data/data_original/'],DS{dataset_option});
                    
                    %获取特征选择数据
                    [FS_TD,FS_TTD] = get_fsdata([genpath,'/data/data_fs/',DS{dataset_option},'/',DS{dataset_option},'_',FS{fs_option},'.mat'],TD,TTD,feature_option);
                    disp(['加载数据：',genpath,'/data/data_original/',DS{dataset_option}]);
                    
                    global tcds;
                    tcds_path = ['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\data_ECOC\',num2str(feature_option),'\',FS{fs_option},'\',DS{dataset_option},'_',FS{fs_option},'_',num2str(feature_option)];
                    load([tcds_path,'.mat']);
                    
                    global decoding;
                    decoding = decodings{decoding_option};
                    %ECOC 训练
                    [dcplx,ica] = ECOC_train(DS{dataset_option},FS_TD,TL,FS_TTD,TTL,Learners{lindex});
                    
                    respath = [genpath,'/data/data_fs_10--150_decoding/data_fs_',num2str(feature_option),'/',FS{fs_option},'/',decodings{decoding_option}];
                    mkdir(respath);
                    
                    save_mat(respath,Learners{lindex},DS{dataset_option},dcplx,ica);
                    
                end % end of decoding
                
            end %end of learners
            %
        end%end of datanames
        
    end%end of fs_method
    
end %end of fs_size

end


function fs_ica_fun(order,DS,FS,Learners,feature_size)

for fs_option = feature_size
    
    for dataset_option=1: size(DS,2)%dataset
        
        for lindex=1: size(Learners,2) %base learner
            
            %加载FS_ICA 数据
            [TD,TL,TTD,TTL]=load_data([genpath,'/data_ica_',num2str(order),'/',FS{fs_option},'/'],DS{dataset_option});
            
            %ECOC 训练
            [dcplx,ica] = ECOC_train(DS,FS_TD,TL,FS_TTD,TTL,Learners{lindex});
            
            %保留正确率等数据
            learnerdata{lindex,dataset_option,1} = dcplx{dataset_option,2} ;
            learnerdata{lindex,dataset_option,2} = ica{dataset_option,2} ;
            
            respath = [genpath,'/data_ica_',num2str(order),'/',FS{fs_option},'/ica_res'];
            mkdir(respath);
            
            %save data as mat
            dcplxpath = [respath,'/dcplx'];
            mkdir(dcplxpath);
            matname=[dcplxpath,'/dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
            save(matname,'dcplx');
            
            dcplxpath = [respath,'/ica'];
            mkdir(dcplxpath);
            matname=[dcplxpath,'/ica_',Learners{lindex},'_',DS{dataset_option},'.mat'];
            save(matname,'ica');
            
            %save data as csv in order by acc and cplx
            save_csv(dcplx,ica,respath,[DS{dataset_option},'_',Learners{lindex}]);
            
        end %end of learners
        
    end%end of datanames
    
    %save data as csv in order by learners
    save_learner(learnerdata,respath,datanames);
    
end

end


%保存dcplx和ica的mat文件
function save_mat(respath,classifier,dataname,dcplx,ica)
if isempty(dcplx) == 0
    dcplxpath = [respath,'/dcplx'];
    mkdir(dcplxpath);
    matname=[dcplxpath,'/dcplx_',classifier,'_',dataname,'.mat'];
    save(matname,'dcplx');
end

if isempty(ica) == 0
    icapath = [respath,'/ica'];
    mkdir(icapath);
    matname=[icapath,'/ica_',classifier,'_',dataname,'.mat'];
    save(matname,'ica');
end
end


function save_learner(Learners,learnerdata,respath,datanames)

disp(['保存分类器结果']);
learnerpath = [respath,'/learner_res'];
mkdir(learnerpath);

%save data as csv in order by learners
accuracy_size = 5;
for lindex = 1:size(Learners,2)
    newdata = [];
    
    for as = 1:accuracy_size
        accdata = [];
        
        for j=1:size(datanames,2)
            temp = learnerdata{lindex,j,1};
            rowdata = [];
            for k=1:size(temp,2)
                rowdata = [rowdata, temp{k}(as)];
            end
            temp = learnerdata{lindex,j,2};
            for k=1:size(temp,2)
                rowdata  = [rowdata, temp{k}(as)];
            end
            newdata = [newdata;rowdata];
        end %end of accuracy_size
        
        newdata = [newdata;zeros(1,size(newdata,2))];
        accdata = [accdata;newdata];
    end %end of datanames
    
    csvwrite([learnerpath,'/',Learners{lindex},'.csv'],newdata);
end %end of learners

end

function [td,dl,testdata,data_test_label]=load_data(path,dataname)
%加载数据
dtype={'traindata','trainlabel','testdata','testlabel'};
for j=1:size(dtype,2)
    matname=[path,'/',dataname,'_',dtype{j},'.mat'];
    load(matname);
end
if(isempty(td)==true || isempty(dl)==true || isempty(testdata)==true || isempty(data_test_label)==true)
    error('Exit:load data error!');
end
end

%已经生成dcplx和ica的mat文件时，用这个函数读取相应mat文件

function [learnerdata] = get_learners_data(genpath,feature_size,fs_method,fs_option,classifier,DName,learnerdata)

global GDS;
[~,inx] = ismember(DName,GDS);

global GLearners;
[~,lindex] = ismember(classifier,GLearners);

respath = [genpath,'_pair/data_fs_',num2str(feature_size),'/',fs_method{fs_option}];
dcplxpath = [respath,'/dcplx'];
matname=[dcplxpath,'/dcplx_',classifier,'_',DName,'.mat'];
load(matname);

respath = [genpath,'/data_fs_',num2str(feature_size),'/',fs_method{fs_option}];
dcplxpath = [respath,'/ica'];
matname=[dcplxpath,'/ica_',classifier,'_',DName,'.mat'];
load(matname);

%保留正确率等数据
learnerdata{lindex,inx,1} = dcplx{inx,2} ;
learnerdata{lindex,inx,2} = ica{inx,2} ;

end

function [fstd,fsttd] = get_fsdata(path,td,ttd,feature_size)
load(path);
selected_feature = importance_order(1:feature_size);
fstd = td(:,selected_feature);
fsttd = ttd(:,selected_feature);
end


function draw_size_change(genpath,DS,FS,Learners)
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
ecocs{10} = [1,2,3,ecoc_3];%F1-F3
ecocs{11} = [4,5,8,ecoc_3];%N2,N3
ecocs{12} = [6,7,ecoc_3];%N4,L3
ecocs{13} = [8,ecoc_3];%Cluster
ecocs{14} = [1,2,3,4,5,8,ecoc_3];%Cluster

subnames = {'4-F1-F3';'4-N2-N3';'4-N4-L3';'4-Cluster';'6-F1-F3';'6-N2-N3';'6-N4-L3';'6-Cluster';'ALLDC';'3-F1-F3';'3-N2-N3';'3-N4-L3';'3-Cluster';'3-N_C1'};
font_size = 9
for ecoc_option = 2
    
    respath1 = ['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-会议1\150-fs-size-4\'];
    mkdir(respath1);
    
    for lindex = 1:size(Learners,2)
        
        for dataset_option = 1:size(DS,2)
            
            clf;
            figure1 = figure('PaperSize',[20.98 29.68]);
            
            set(figure1,'Position',[76 130 939 645]);
            
            for fs_option = 1:size(FS,2)
                
                acc = [];
                
                for i =5:5:150 % feature size
                    
                    %%获取dcplx MAT 文件
                    dcplxmat = [genpath,'/data/data_fs_10--150/data_fs_',num2str(i),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{dataset_option}];
                    icamat= [genpath,'/data/data_fs_10--150/data_fs_',num2str(i),'/',FS{fs_option},'/','ica/ica_',Learners{lindex},'_',DS{dataset_option}];
                    load(dcplxmat);
                    load(icamat);
                                      
                    %获取ALL ECOC正确率
                    position = size(dcplx,1);
                    dcplx = dcplx{position,2};
                    ica = ica{position,2};
                    temp = [dcplx ica];
                    for j = 1:size(temp,2)
                        temp{j} = temp{1,j}(1);
                    end
                    acc = [acc;temp];
                    
                end %end of feature size
                
                if(fs_option == 2 || 3)
                    subplot(2,2,fs_option+1,'Parent',figure1,'FontSize',font_size);
                elseif(fs_option==1)
                    subplot('Parent',figure1,'FontSize',font_size);
                end
                
                draw_single_fs_size(cell2mat(acc),fs_option,ecocs{ecoc_option});
                
                legend(lengend_names(ecocs{ecoc_option}),'Location','best');
                saveas(gcf ,[respath1,'/',FS{fs_option},'_',Learners{lindex},'_',DS{dataset_option},'_',subnames{ecoc_option}],'fig');
                saveas(gcf ,[respath1,'/',FS{fs_option},'_',Learners{lindex},'_',DS{dataset_option},'_',subnames{ecoc_option}],'tiff');
                
            end%end of learner
            
        end%end of dataset
        
    end
end
end

function draw_single_fs_size(res,fs_option,ecoc)

fs_names = {'Roc','Ttest','Wilcoxon'};
font_size = 12;
x = 5:5:150;

colors =[0,0,0; 0,0,1; 0.3,0,0.5; 0,0.6,1; 0.6,0,0; 0.1,0.1,0.4; 0.84,0.2,0.2; 0.5,0.2,0.9;1,0.1,0.6; 0.2,0.6,0;0.6,0.4,0.2;0.2,0.5,0.2;0,0,0; 0,0,1;0.3,0.3,0.3;0.45,0,0;0,0.45,0];
linestyle = {':','-','--','-','-.','--','-.','-','-.','--',':','-','-','-','-','-.','--'};
marker = {'<','>','^','*','s','d','o','p','h','v','+','*','d','o','p','h','v'};

for i = 1:size(ecoc,2)
    plot(x,res(:,ecoc(i)),'Color',colors(i,:),'LineStyle',linestyle{i},'Marker',marker{i});hold on
end

xlabel('Feature Size','FontSize',font_size);
ylabel('Accuracy','FontSize',font_size);

title(fs_names{fs_option});
hold off

end

function draw_acc_cplx_fun(genpath,DS,FS,Learners,feature_size)
ecocnames = {'F1','F2','F3','N2','N3','N4','L3','Cluster'};

linestyle={'p','*','d','s','+','o','x','<'};

picrespath = [genpath,'\pic\期刊\new_N3\Acc_Cplx'];
mkdir(picrespath);
fontsize = 8;
for num = feature_size
    
    resfilepath = ['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-会议1\LineChar\',num2str(num)];
    mkdir(resfilepath);
    
    for fs_option =  1:size(FS,2)
        
        for ecoc_option = [4,5]
            
            for lindex = 1:size(Learners,2)
                
                clf;%清空figure
                figure
                for data_option = 1:size(DS,2)
                    
                    %加载数据
                    dcplxmat = [genpath,'/data/data_fs_10--150/data_fs_',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}];
                    disp(['加载的dcplx是：',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}]);
                    load(dcplxmat);
                    
                    position = size(dcplx,1);    
                    accuracy = dcplx{position,2}{1,ecoc_option}(1);
                    allcplx = dcplx{position,6}{1,ecoc_option};
                    cplxsum = 0;
                    for cplxindex = 1:size(allcplx,2)
                        cplxsum = cplxsum + sum(allcplx{1,cplxindex});
                        disp(['cplxsum:',num2str(cplxsum)]);
                    end
                    
                    plot(cplxsum,accuracy,linestyle{data_option},'markersize',8);hold on
                    
                end%end of datanames
                
                xlabel('Cplx Sum','Fontsize',fontsize); %x轴
                ylabel('Accuracy','Fontsize',fontsize); %y轴
                grid on;
                title(ecocnames{ecoc_option});
                legend(DS,'location','best');
                
                hold off
                saveas(gca ,[resfilepath,'\',ecocnames{ecoc_option},'_',num2str(num),'_',FS{fs_option},'_',Learners{lindex}],'fig');
                saveas(gca ,[resfilepath,'\',ecocnames{ecoc_option},'_',num2str(num),'_',FS{fs_option},'_',Learners{lindex}],'tiff');
                
            end%end of learners
            
        end%end of ecoc
        
    end%end of fs_method
    
end%end of num


end%end of function

function draw_time_fun(genpath,DS,FS,Learners,feature_size)
ecocnames = {'F1','F2','F3','N2','N3','N4','L3','Cluster','CF','OVO','OVA','Ordinal','DECOC','ECOCONE','Forest'};
picrespath = [genpath,'\pic\期刊\new_N3\time'];
mkdir(picrespath);

for num = feature_size
    
    resfilepath = [picrespath,'\',num2str(num)];
    mkdir(resfilepath);
    
    for fs_option = 1:3
        
        for lindex = 1:size(Learners,2)
            
            clf;%清空figure
            figure
            
            for data_option=1:size(DS,2)
                
                dcplxmat = [genpath,'/data_fs_10--150_pair_newN3/data_fs_',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}];
                disp(['加载的dcplx是：',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}]);
                load(dcplxmat);
                
                icamat = [genpath,'/data_fs_10--150_pair_newN3/data_fs_',num2str(num),'/',FS{fs_option},'/','ica/ica_',Learners{lindex},'_',DS{data_option}];
                disp(['加载的dcplx是：',num2str(num),'/',FS{fs_option},'/','ica/ica_',Learners{lindex},'_',DS{data_option}]);
                load(icamat);
                
                times = dcplx{data_option,5};
                times = [times,ica{data_option,5}];
                
                [sort_times,index] = sort(times);
                
                x = (1:15)';
                bar(x,sort_times');
                text(x,sort_times',num2str(sort_times','%0.3f'),...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom');
                
                new_ecocnames = 1:1:15;
                for i = 1:size(index,2)
                    new_ecocnames{i} = ecocnames{index(i)};
                end
                
                set(gca,'XTickLabel',new_ecocnames);
                set(gca,'XTickLabelRotation',90);
                xlabel('ECOC','Fontsize',fontsize); %x轴
                ylabel('times/s','Fontsize',fontsize); %y轴
                
                title(DS{data_option});
                
                saveas(gca ,[resfilepath,'\',num2str(num),'_',FS{fs_option},'_',Learners{lindex},'_',DS{data_option}],'fig');
                saveas(gca ,[resfilepath,'\',num2str(num),'_',FS{fs_option},'_',Learners{lindex},'_',DS{data_option}],'tiff');
                
                
            end%end of datanames
            
        end%end of learners
        
    end%end of fs_method
    
end%end of num

end


function draw_ecoc_cplx(genpath,DS,FS,DC,Learners,feature_size)

marker1 = {'p','*','d',};
marker2 = {'s','o','x','<','^'};
colors =[0,0,0; 0.8,0,0; 0,0,1; 0.3,0,0.5; 0,0.6,1; 0.6,0,0;0.84,0.6,0.6; 0.5,0.2,0.9;];

datasets = {};
for k = 1:7
    for d = k+1:8
        datasets = [datasets [k,d]];
    end
end

picrespath = [genpath,'\pic\期刊\new_N3_F3\ecoc_cplx_accuracy'];
mkdir(picrespath);

for num = feature_size
    
    for fs_option = size(FS,2)
        
        resfilepath = [picrespath,'\',num2str(num),'\',FS{fs_option}];
        mkdir(resfilepath);
        
        for lindex = 1:size(learners,2)
            
            for dc_option = 1:size(DC,2)
                
                if(dc_option == 6 || dc_option==7)
                    continue;
                end
                
                for set_option = 1:size(datasets,2)
                    
                    setfilepath = [resfilepath,'\',num2str(set_option)];
                    mkdir(setfilepath);
                    
                    
                    clf;%清空figure
                    set(0,'DefaultFigureVisible', 'on');
                    figure
                    dataset = datasets{set_option};
                    for i = 1:size(dataset,2)
                        dcplx_accuracy = [];
                        
                        data_option = dataset(i);
                        
                        %加载矩阵
                        dcplxmat = [genpath,'/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}];
                        disp([genpath,'/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option}]);
                        load(dcplxmat);
                        
                        load([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(num),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                        disp([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(num),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                        
                        accuracy_matrix = dcplx{data_option,2};
                        for k = 1:size(accuracy_matrix,2)
                            dcplx_accuracy(k) = accuracy_matrix{1,k}(1);
                        end
                        
                        x = 1:length(dcplx_accuracy);
                        
                        [hAx,hLine1,hLine2] = plotyy(x,dcplx_accuracy,x,dcplx_cplx_sum); hold on;
                        %设置颜色和marker
                        hLine1.LineStyle = '-';
                        hLine2.LineStyle = '-.';
                        hLine1.Marker = marker1{i};
                        hLine2.Marker = marker2{i};
                        
                        hLine1.Color = colors(i,:);
                        hLine2.Color = colors(i,:);
                        
                    end%end of datanames
                    
                    grid on;
                    legend(DS(dataset),'location','best');
                    title('cplx_accuracy');
                    xlabel('times');
                    ylabel(hAx(1),'accuracy') ;
                    ylabel(hAx(2),'cplx_mean');
                    
                    picresname = [setfilepath,'\',FS{fs_option},'_',Learners{lindex},'_',dc{dc_option},'_set',num2str(set_option),'_dcplx'];
                    saveas(gca ,picresname,'fig');
                    saveas(gca ,picresname,'tiff');
                    disp(['文件地址是：',resfilepath]);
                    disp(['保存文件名是：',picresname]);
                    
                end
            end%end of dc
        end%end of learner
        
    end%end of fs_method
    
end%end of num

end%end of function

%返回的是矩阵的平均值
function cplx_sum = get_ecoc_cplx(ecocs,td,dl,dc_name)
cplx_sum = zeros(1,size(ecocs,2));
for e = 1:size(ecocs,2)%每个矩阵
    each_ecoc = ecocs{1,e};
    for column = 1:size(each_ecoc,2)
        c11 = find(each_ecoc(:,column)==1);
        c12 = find(each_ecoc(:,column)==-1);
        cplx_sum(e) = cplx_sum(e) + get_complexity(dc_name,td,dl,c11,c12);
    end
    cplx_sum(e) = cplx_sum(e)/size(each_ecoc,2);
end
end

function cplx = get_complexity(dc_option,traindata,trainlabel,c11,c12)
switch(dc_option)
    case 'F1'
        cplx = get_complexityF1(c11,c12,traindata,trainlabel);
    case 'F2'
        cplx = get_complexityF2(c11,c12,traindata,trainlabel);
    case 'F3'
        cplx = get_complexityF3(c11,c12,traindata,trainlabel);
    case 'N2'
        cplx = get_complexityN2(c11,c12,traindata,trainlabel);
    case 'N3'
        cplx = get_complexityN3(c11,c12,traindata,trainlabel);
    case 'N4'
        cplx = get_complexityN4(c11,c12,traindata,trainlabel);
    case 'L3'
        cplx = get_complexityL3(c11,c12,traindata,trainlabel);
    case 'Cluster'
        cplx = get_complexityCluster(c11,c12,traindata,trainlabel);
    otherwise
        error('Exit:error option!');
end

end

function draw_PD(genpath,DS,FS,Learners,feature_size)
picrespath = [genpath,'\data\论文结果整理-期刊-pair\new_N3_F3\ecoc_PD'];
mkdir(picrespath);

for num = feature_size
    
    for fs_option = 1:size(FS,2)
        
        resfilepath = [picrespath,'\',num2str(num),'\',FS{fs_option}];
        mkdir(resfilepath);
        
        for data_option=1:size(DS,2)
            
            %加载复杂度矩阵
            dcplxmat = [genpath,'/data/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_svm_',DS{data_option}];
            disp(['加载的dcplx是：',num2str(num),'/',FS{fs_option},'/','dcplx/dcplx_svm_',DS{data_option}]);
            load(dcplxmat);
            
            global GDS;
            [~,inx] = ismember(DS{data_option},GDS);
            
            %计算复杂度的PD
            dcplx_ecocs = dcplx{inx,7};
            dcplx_ecocs(6)=[];
            dcplx_ecocs(7)=[];
            ecoc_num = size(dcplx_ecocs,2);
            dcplx_PD_matrix = zeros(ecoc_num,ecoc_num);
            for  ci = 1:ecoc_num
                for cj = ci+1:ecoc_num
                    dcplx_PD_matrix(ci,cj) = get_PD(dcplx_ecocs{ci},dcplx_ecocs{cj})/(ecoc_num*ecoc_num);
                end
            end
            
            %加载其他算法的矩阵
            %             icamat = [genpath,'/data/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(num),'/',FS{fs_option},'/','ica/ica_svm_',DS{data_option}];
            %             disp(['加载的dcplx是：',num2str(num),'/',FS{fs_option},'/','ica/ica_svm_',DS{data_option}]);
            %             load(icamat);
            %             ica_ecocs = ica{inx,7};
            %             ica_ecocs(1) = [];
            %             ica_ecocs(4) = [];
            
            %             %计算复杂度的PD
            %             ica_ecocs = [dcplx_ecocs ica_ecocs];%合并ecoc
            %             ecoc_num = size(ica_ecocs,2);
            %             ica_PD_matrix = zeros(ecoc_num,ecoc_num);
            %             for  ci = 1:ecoc_num
            %                 for cj = ci+1:ecoc_num
            %                     ica_PD_matrix(ci,cj) = get_PD(ica_ecocs{ci},ica_ecocs{ci});
            %                 end
            %             end
            
            fileresname = [resfilepath,'\',FS{fs_option},'_',DS{data_option},'_dcplx_PD_6.csv'];
            csvwrite(fileresname,dcplx_PD_matrix);
            disp(['保存文件地址是：',resfilepath]);
            disp(['保存的文件名是：',fileresname]);
            
            %             fileresname = [resfilepath,'\',FS{fs_option},'_',DS{data_option},'_ica_PD.csv'];
            %             csvwrite(fileresname,ica_PD_matrix);
            %             disp(['保存文件地址是：',resfilepath]);
            %             disp(['保存的文件名是：',fileresname]);
            
        end%end of datanames
        
        
    end%end of fs_method
    
end%end of num

end


function PD = get_PD(ecoc1,ecoc2)
PD = 0;
for i = 1:size(ecoc1,2)
    columnsum = zeros(1,size(ecoc2,2));
    for j = 1:size(ecoc2,2)
        columnsum(j) = sum(ecoc1(:,i) ~= ecoc2(:,j));
    end
    PD = PD + min(columnsum);
end
end


function draw_test(genpath,DS,FS,Learners,DC,feature_size)

picrespath = [genpath,'\pic\期刊\new_N3_F3\cplx_acc_test'];
mkdir(picrespath);

for feature_option = feature_size
    
    for fs_option = 1:size(FS,2)
        
        resfilepath = [picrespath,'\',num2str(feature_option),'\',FS{fs_option}];
        mkdir(resfilepath);
        
        for lindex = 1:size(Learners,2)
            
            for data_option = 1:size(DS,2)%数据集
                
                %加载复杂度矩阵
                dcplxmat = [genpath,'/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat'];
                disp(['加载的dcplx是：',genpath,'/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat']);
                load(dcplxmat);
                
                %得到正确率-矩阵
                accuracy_matrix = dcplx{data_option,11};
                for i = 1:size(accuracy_matrix,2)
                    dcplx_accuracy(i) = accuracy_matrix{1,i}(1);%得到每个数据复杂度算法的结果
                end
                dcplx_ecocs = dcplx{data_option,7};
                
                C = [];
                for dc_option = [1,2,3,4,5,8]%数据复杂度测度
                    
                    %计算ecoc复杂度
                    %dcplx_cplx_sum = get_ecoc_cplx(dcplx_ecocs,td,dl,dc{dc_option});
                    %save([resfilepath,'\',fs_method{fs_option},'_',num2str(num),'_',datanames{data_option},'_',dc{dc_option},'_dcplx_cplx_sum.mat'],'dcplx_cplx_sum');
                    load([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(num),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                    disp([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(num),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                    
                    cor = corrcoef(dcplx_accuracy,dcplx_cplx_sum);
                    C = [C cor(1,2)]%计算相关系数-R表示ij元素间的相关性
                    
                end%end of datanames
                
                Csum = [Csum;C];
                
            end%end of datasets
            fileresname = [resfilepath,'\',FS{fs_option},'_',Learners{lindex},'_Accuracy_Correlation_test.csv'];
            csvwrite(fileresname,Csum);
        end%end of learners
        
    end%end of fs_method
    
end%end of num

end

function draw_classifier_test(genpath,DS,FS,Learners,feature_size)

global GDS;
table_header = {'F1','F2','F3','N2','N3','Cluster'};
picrespath = [genpath,'\data\论文结果整理-期刊-pair\new_N3_F3\cplx_acc_classifier_test-正确率'];
mkdir(picrespath);

for feature_option = feature_size
    
    for fs_option = 1:size(FS,2)
        
        resfilepath = [picrespath,'\',num2str(feature_option),'\',FS{fs_option}];
        mkdir(resfilepath);
        
        for lindex = 1:size(Learners,2)
            
            Csum = [];
            for data_option = 1:size(DS,2)%数据集
                
                [~,inx] = ismember(DS{data_option},GDS);
                
                %加载复杂度矩阵
                dcplxmat = [genpath,'/data/论文结果整理-期刊-pair/new_N3_F3/acc_dcplx_classifier/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat'];
                load(dcplxmat);
                disp(['加载的dcplx是：',genpath,'/data/论文结果整理-期刊-pair/new_N3_newF3/data_cplx_classifier/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat']);
                
                %得到正确率-矩阵
                accuracy_matrix = dcplx{inx,12};
                cplx = dcplx{inx,13};
                C = [];
                dc_option = [1,2,3,4,5,8];
                for inx = 1:6 %数据复杂度测度
                    cor = corrcoef(accuracy_matrix{dc_option(inx)},cplx{inx});
                    C = [C cor(1,2)]%计算相关系数-R表示ij元素间的相关性
                end%end of datanames
                Csum = [Csum;C];
                
            end%end of datasets
            
            fileresname = [resfilepath,'\',FS{fs_option},'_',Learners{lindex},'_Accuracy_Correlation_test.csv'];
            csvwrite(fileresname,Csum);
            
        end%end of learners
        
    end%end of fs_method
    
end%end of num

end


function draw_accuracy_fscore(genpath,DS,FS,Learners,DC,DC_Name,feature_size)

linestyle={'pr','*r','dr','sr','+r','^r','pb','*b','db','sb','+b','^b'};

%创建结果文件夹
picrespath = [genpath,'\pic\期刊1\new_N3_F3\accuracy_cplx'];
mkdir(picrespath);

for feature_option = feature_size
    
    for fs_option = 1:size(FS,2)
        
        for lindex = 1:size(Learners,2)
            
            for dc_option = 1:size(DC,2)%数据复杂度测度
                
                clf
                figure;
                acc_total = [];
                Fscore_total = [];
                cplx_total = [];
                for data_option = 1:size(DS,2)%数据集
                    
                    %加载结果
                    dcplxmat = [genpath,'/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat'];
                    disp(['加载的dcplx是：',genpath,'/data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat']);
                    load(dcplxmat);
                    
                    %得到正确率和Fscore-矩阵
                    accuracy_matrix = dcplx{data_option,2};
                    Fscore_matrix = dcplx{data_option,2};
                    for i = 1:size(accuracy_matrix,2)
                        dcplx_accuracy(i) = accuracy_matrix{1,i}(1);
                        dcplx_fscore(i) = Fscore_matrix{1,i}(5);
                    end
                    
                    load([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(fs_option),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                    disp([genpath,'\pic\期刊\new_N3_F3\cplx_mat\',num2str(num),'\',FS{fs_option},'\',FS{fs_option},'_',num2str(fs_option),'_',DS{data_option},'_',DC{dc_option},'_dcplx_cplx_sum.mat']);
                    
                    acc_total = [acc_total dcplx_accuracy([1,2,3,4,5,8])];
                    Fscore_total = [Fscore_total dcplx_fscore([1,2,3,4,5,8])];
                    cplx_total = [cplx_total dcplx_cplx_sum([1,2,3,4,5,8])];
                    
                end%end of datasets
                
                for s = 1:size(acc_total,2)
                    scatter3(cplx_total(s),acc_total(s),Fscore_total(s),linestyle{s});hold on;
                end
                
                legend(dc_legend([1,2,3,4,5,8]));
                
                xlabel('complexity');  %设置x轴名称
                ylabel('accuracy');  %设置y轴名称
                zlabel('Fscore'); %设置z轴名称
                grid on;
                axis square;      %等比例
                
                %保存文件
                saveas(gca ,[picrespath,'/',FS{fs_option},'_',Learners{lindex},'_',DC{dc_option},'_accuracy'],'fig');
                saveas(gca ,[picrespath,'/',FS{fs_option},'_',Learners{lindex},'_',DC{dc_option},'_accuracy'],'tiff');
                
            end%end of complexity
            
        end%end of learners
        
    end%end of fs_method
    
end%end of num

end


