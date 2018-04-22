% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% ica ecoc test
function [data_test_label,all_labels,accratio,elapsed,tcplx,tcds]=ica_ecoc_random(td,dl,testdata,data_test_label,option,lindex)
% % % init
     tcds={};
     tcplx=[];
     all_labels={};
     accratio={};
     elapsed=[];  

    if(lindex<=5)
       [elapsed,accratio,all_labels,tcds]=get_learners(tcds,td,dl,testdata,data_test_label,option,lindex,elapsed,accratio,all_labels);      
    else
       [elapsed,accratio,all_labels,tcds]=get_AANlearner(tcds,td,dl,testdata,data_test_label,option,lindex,elapsed,accratio,all_labels);      
    end    
end

function [elapsed,accratio,all_labels,tcds]=get_learners(tcds,td,dl,testdata,data_test_label,option,lindex,elapsed,accratio,all_labels)     
%   新的ecoc train
    global cds;
    learners={'discriminant','knn','naivebayes','svm','tree'};
    codings={'denserandom','sparserandom'};        
    for i=1:size(codings,2)
        cds=[];
        tstart = tic;
        ecocmodel=fitcecoc(td,dl,'Coding',codings{i},'learners',learners{lindex});

        tcds{size(tcds,2)+1}=ecocmodel.CodingMatrix;
        Labels=predict(ecocmodel,testdata);
        len=size(elapsed,2);
        elapsed(len+1) = toc(tstart); %计算的是从tstart开始到toc的时间间隔                

        %计算准确度
        accratio{len+1}=Fscore(data_test_label,Labels);%准确度测度个数
        all_labels{len+1}=Labels;            
    end
end


function [elapsed,accratio,all_labels,tcds]=get_AANlearner(tcds,td,dl,testdata,data_test_label,option,lindex,elapsed,accratio,all_labels)
% % %确定ADA or NMC learner
     learners={'NMC','ADA'};
     test={'NMCTest','ADAtest'};
     lindex=lindex-5;
     codings={'denserandom','sparserandom'};             
     for i=1:size(codings,2)
        global cds;
        cds=[];       
        ecocmodel=fitcecoc(td,dl,'Coding',codings{i});
        cds=ecocmodel.CodingMatrix;
        tcds{size(tcds,2)+1}=cds;  
        clear Parameters;
        Parameters.coding='OneVsOne';%生成ECOC
        Parameters.decoding='ED';%解码
        Parameters.base=learners{lindex};%分类器
        Parameters.base_params.iterations=50;%迭代次数
        Parameters.base_test=test{lindex};%

        tstart = tic;
        [Classifiers,Parameters]=ECOCTrain(td,dl,Parameters,cds);%训练数据
        [Labels,Values,confusion]=ECOCTest(testdata,Classifiers,Parameters,data_test_label);%测试数据          
        len=size(elapsed,2);
        elapsed(len+1) = toc(tstart); %计算的是从tstart开始到toc的时间间隔                

        %计算准确度
        accratio{len+1}=Fscore(data_test_label,Labels);%准确度测度个数
        all_labels{len+1}=Labels;
     end     
end
