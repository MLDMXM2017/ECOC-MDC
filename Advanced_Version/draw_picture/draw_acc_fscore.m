%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the scatter chart of accuracy and fscore

%##########################################################################



function draw_acc_fscore(DS,FS,Learners,DC,feature_size)

linestyle={'pr','*r','dr','sr','+r','^r','pb','*b','db','sb','+b','^b'};

%create result file
pic_res_path = '../data/accuracy_cplx/';
mkdir(pic_res_path);

for feature_option = feature_size
    
    for fs_option = 1:size(FS,2)
        
        for lindex = 1:size(Learners,2)
            
            for dc_option = 1:size(DC,2)
                
                clf
                figure;
                acc_total = [];
                Fscore_total = [];
                cplx_total = [];
                for data_option = 1:size(DS,2)
                    
                    %加载结果
                    dcplxmat = ['../data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat'];
                    disp(['加载的dcplx是：','../data_fs_10--150_pair_newN3_newF3/data_fs_',num2str(feature_option),'/',FS{fs_option},'/','dcplx/dcplx_',Learners{lindex},'_',DS{data_option},'.mat']);
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
                
                xlabel('complexity');
                ylabel('accuracy');
                zlabel('Fscore');
                grid on;
                axis square;
                
                %保存文件
                saveas(gca ,[pic_res_path,FS{fs_option},'_',Learners{lindex},'_',DC{dc_option},'_accuracy'],'fig');
                saveas(gca ,[pic_res_path,FS{fs_option},'_',Learners{lindex},'_',DC{dc_option},'_accuracy'],'tiff');
                
            end%end of complexity
            
        end%end of learners
        
    end%end of fs_method
    
end%end of num

end
