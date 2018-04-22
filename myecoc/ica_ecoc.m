% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% ica ecoc test
function [data_test_label,all_labels,accratio,elapsed,tcplx,tcds,confmat,binary_y,classifier_error,classifier_right,ECOC_cplx]=ica_ecoc(td,dl,testdata,data_test_label,option,classifier)

% % % init
tcds={};
tcplx=[];
all_labels={};
accratio={};
elapsed=[];
confmat = {};
binary_y = {};
classifier_error = {};
classifier_right = {};
ECOC_cplx = {};

%      option='data_cplx';
% % %是否计算cplx
if(strcmp(option,'data_cplx')==1)
    global tcds;
    data_train_lu=unique(dl);
    [tcds,tcplx]=get_all_cds(size(data_train_lu,1),td,dl,'ALL');
    tcds{size(tcds,2)+1}=get_emsemble(tcds{1},tcds{2},tcds{3});%合并F1-F3
elseif(size(option,2) > 1 && strcmp(option,'ica')~=1 )
    tcds = option;
    option = 'data_cplx';
end

if(strcmp(classifier,'ADA')~=1 && strcmp(classifier,'NMC')~=1)
    [elapsed,accratio,all_labels,tcds,confmat,binary_y,classifier_error,classifier_right,ECOC_cplx]=get_learners(tcds,td,dl,testdata,data_test_label,option,classifier,elapsed,accratio,all_labels,confmat,binary_y,classifier_error,classifier_right,ECOC_cplx);
else
    [elapsed,accratio,all_labels,tcds,confmat]=get_AANlearner(tcds,td,dl,testdata,data_test_label,option,classifier,elapsed,accratio,all_labels,confmat);
end
end

%%SVM,discriminant,NB,tree
function [elapsed,accratio,all_labels,tcds,confmat,binary_y,classifier_error,classifier_right,ECOC_cplx]=get_learners(tcds,td,dl,testdata,data_test_label,option,classifier,elapsed,accratio,all_labels,confmat,binary_y,classifier_error,classifier_right,ECOC_cplx)
%   新的ecoc train
global cds;
global decoding;
disp(['分类器训练:',classifier]);
if(strcmp(option,'ica')==1)
    %%OVA,OVO,DR,SR--MATLAB2015
%     codings={'OneVsOne','OneVsAll','Random'};
%         codings = {'OneVsOne','Random','OneVsAll'};
%     for i = 1:size(codings,2)
%         cds=[];
%         tstart = tic;
%         ecocmodel=fitcecoc(td,dl,'Coding',codings{i},'learners',classifier);
%         cds = ecocmodel.CodingMatrix;
%                 Labels=predict(ecocmodel,testdata);
%                 tcds{size(tcds,2)+1} = cds;
%         
%                 [confusion,~]=confusionmat(data_test_label,Labels);
%                 elapsed = [elapsed toc(tstart)];%训练和预测时间
%                 confmat= [confmat confusion];%混淆矩阵
%                 accratio = [accratio  Fscore(data_test_label,Labels)];%准确率
%                 all_labels= [all_labels  Labels];%test预测label
%                 end
%         clear Parameters;
%         Parameters.coding = codings{i};%生成ECOC
%         Parameters.decoding = 'ED';%解码
%         Parameters.base = 'MySVM';%分类器
%         Parameters.base_test = 'MySVM_Test';%分类器
%         [Classifiers,Parameters] = ECOCTrain(td,dl,Parameters,[]);%训练数据
%         [Labels,~,confusion] = ECOCTest(testdata,Classifiers,Parameters,data_test_label);
%         confmat{size(confmat,2)+1} = confusion;%计算分类器准确率矩阵
%         计算准确度
%         accratio = [accratio Fscore(data_test_label,Labels)];%准确度测度个数
%         all_labels = [all_labels Labels];        
%     end
    %% DECOC，ECOCOne，FroestECOC--ECOC library
    codings={'OneVsOne','OneVsAll','Random','DECOC','ECOCONE','Forest'};
    for i=1:size(codings,2)
        tstart = tic;
        
        clear Parameters;
        Parameters.coding = codings{i};%生成ECOC
        Parameters.decoding = 'ED';%解码
        Parameters.base = 'MySVM';%分类器
        Parameters.base_test = 'MySVM_Test';%分类器
        [Classifiers,Parameters] = ECOCTrain(td,dl,Parameters,[]);%训练数据
        [Labels,~,confusion] = ECOCTest(testdata,Classifiers,Parameters,data_test_label);
        cds = Parameters.ECOC;%%%%%%获取ECOC matrix
        
        tcds{size(tcds,2)+1} = cds;
        [confusion,~] = confusionmat(data_test_label,Labels);
        elapsed = [elapsed toc(tstart)];%训练和预测时间
        confmat= [confmat confusion];%混淆矩阵
        accratio = [accratio  Fscore(data_test_label,Labels)];%准确率
        all_labels= [all_labels  Labels];%test预测label
        
    end
elseif(strcmp(option,'data_cplx')==1)
    
    DC_OPTIONS = {'F1','F2','F3','N2','N3','N4','L3','Cluster','CF'};
    for i=1:size(tcds,2)%复杂度的个数
        
        %         cds=tcds{i};
        %         clear Parameters;
        %         Parameters.coding = 'OneVsOne';%生成ECOC
        %         Parameters.decoding = decoding;%解码
        %         Parameters.base = 'MySVM';%分类器
        %         Parameters.base_test = 'MySVM_Test';%分类器
        %         [Classifiers,Parameters] = ECOCTrain(td,dl,Parameters,cds);%训练数据
        %         [Labels,~,confusion] = ECOCTest(testdata,Classifiers,Parameters,data_test_label);
        %         confmat{size(confmat,2)+1} = confusion;%计算分类器准确率矩阵
        %         %计算准确度
        %         accratio = [accratio Fscore(data_test_label,Labels)];%准确度测度个数
        %         all_labels = [all_labels Labels];
        %
        %         X = get_X(ecocmodel.BinaryLearners,testdata);
        %
        %         binary_y = [binary_y X];
        %         classifier_error = [classifier_error get_classifier_error(cds, X,data_test_label)];
        %         classifier_right = [classifier_right get_classifier_right(cds, X,data_test_label)];
        %         if strcmp(DC_OPTIONS{i},'CF') == 0
        %             ECOC_cplx = [ECOC_cplx get_ecoc_cplx(cds,DC_OPTIONS{i},testdata,data_test_label)];
        %         end
        
        cds=tcds{i};
        tstart = tic;
        ecocmodel=fitcecoc(td,dl,'learners',classifier);
        Labels = predict(ecocmodel,testdata);
        
        [confusion,~]=confusionmat(data_test_label,Labels);
        elapsed = [elapsed toc(tstart)];%训练和预测时间
        confmat = [confmat confusion];%混淆矩阵
        accratio = [accratio  Fscore(data_test_label,Labels)];%准确率
        all_labels= [all_labels  Labels];%test预测label
        
        X = get_X(ecocmodel.BinaryLearners,testdata);
        
        binary_y = [binary_y X];
        classifier_error = [classifier_error get_classifier_error(cds, X,data_test_label)];
        classifier_right = [classifier_right get_classifier_right(cds, X,data_test_label)];
        
        global TD;
        global TL;
        TD = td;
        TL = dl;
        if strcmp(DC_OPTIONS{i},'CF') == 0
            ECOC_cplx = [ECOC_cplx get_ecoc_cplx(cds,DC_OPTIONS{i},testdata,data_test_label)];
        end
    end
end
end


%NMC,ADA
function [elapsed,accratio,all_labels,tcds,confmat]=get_AANlearner(tcds,td,dl,testdata,data_test_label,option,lindex,elapsed,accratio,all_labels,confmat)
% % %确定ADA or NMC learner

learners={'NMC','ADA'};
test={'NMCTest','ADAtest'};
disp(['分类器训练：',classifier]);

global cds;
% % %确定是ica or cplx
if(strcmp(option,'ica')==1)
    codings={'onevsone','denserandom','onevsall','ordinal','sparserandom'};
    for i=1:size(codings,2)
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
        [Labels,~,confusion]=ECOCTest(testdata,Classifiers,Parameters,data_test_label);%测试数据
        
        elapsed = [elapsed toc(tstart)];%训练和预测时间
        confmat= [confmat confusion];%混淆矩阵
        accratio = [accratio  Fscore(data_test_label,Labels)];%准确率
        all_labels= [all_labels  Labels];%test预测label
    end
    
    % 获取 DECOC，ECOCOne，FroestECOC
    codings={'DECOC','ECOCONE','Forest'};
    for i=1:size(codings,2)
        clear Parameters;
        Parameters.coding=codings{i};%生成ECOC
        Parameters.decoding='ED';%解码
        Parameters.base=learners{lindex};%分类器
        Parameters.base_params.iterations=50;%迭代次数
        Parameters.base_test=test{lindex};%测试工具
        
        tstart = tic;
        [Classifiers,Parameters]=ECOCTrain(td,dl,Parameters,[]);%训练数据
        [Labels,~,confusion]=ECOCTest(testdata,Classifiers,Parameters,data_test_label);%测试数据
        len=size(elapsed,2);
        tcds{size(tcds,2)+1}=Parameters.ECOC;
        
        [confusion,~]=confusionmat(data_test_label,Labels);
        elapsed = [elapsed toc(tstart)];%训练和预测时间
        confmat= [confmat confusion];%混淆矩阵
        accratio = [accratio  Fscore(data_test_label,Labels)];%准确率
        all_labels= [all_labels  Labels];%test预测label
    end
elseif(strcmp(option,'data_cplx')==1)
    for i=1:size(tcds,2)%数据复杂度测度
        Parameters.coding='OneVsOne';%生成ECOC
        Parameters.decoding='ED';%解码
        Parameters.base=learners{lindex};%分类器
        Parameters.base_params.iterations=50;%迭代次数
        Parameters.base_test=test{lindex};%测试工具
        
        tstart = tic;
        [Classifiers,Parameters]=ECOCTrain(td,dl,Parameters,tcds{i});%训练数据
        [Labels,~,confusion]=ECOCTest(testdata,Classifiers,Parameters,data_test_label);%测试数据
        
        [confusion,~]=confusionmat(data_test_label,Labels);
        elapsed = [elapsed toc(tstart)];%训练和预测时间
        confmat= [confmat confusion];%混淆矩阵
        accratio = [accratio  Fscore(data_test_label,Labels)];%准确率
        all_labels= [all_labels  Labels];%test预测label
    end
end
end

function classifier_error = get_classifier_error(ECOC,predicted_Y,TTL)
%     classifier_right = zeros(1,size(ECOC,2));
%     for i = 1:size(TTL,1)
%        true_binary_y = ECOC(TTL(i),:);
%        predicted_y = predicted_Y(i,:);
%        classifier_right = classifier_right + (true_binary_y == predicted_y);
%     end
%     classifier_error = 1 - classifier_right/size(TTL,1);
classifier_error = [];
for column = 1:size(ECOC,2)
    samples_inx = [];
    true_label = [];
    classes = find(ECOC(:,column) == 1)';%positive classes
    for i = 1:size(classes,2)
        inx = find(TTL == classes(i));
        samples_inx = [samples_inx;inx];
    end
    
    true_label = ones(size(samples_inx,1),1);
    
    classes = find(ECOC(:,column) == -1)';%negative classes
    for i = 1:size(classes,2)
        inx = find(TTL == classes(i));
        samples_inx = [samples_inx;inx];
    end
    
    true_label =[true_label;-ones(size(samples_inx,1)-size(true_label,1),1)];
    
    predict = predicted_Y(samples_inx,column);
    error = sum(predict ~= true_label)/size(samples_inx,1);
    classifier_error = [classifier_error error];
end

end

function classifier_right = get_classifier_right(ECOC,predicted_Y,TTL)
classifier_right = [];
for column = 1:size(ECOC,2)
    samples_inx = [];
    true_label = [];
    classes = find(ECOC(:,column) == 1)';%positive classes
    for i = 1:size(classes,2)
        inx = find(TTL == classes(i));
        samples_inx = [samples_inx;inx];
    end
    
    true_label = ones(size(samples_inx,1),1);
    
    classes = find(ECOC(:,column) == -1)';%negative classes
    for i = 1:size(classes,2)
        inx = find(TTL == classes(i));
        samples_inx = [samples_inx;inx];
    end
    
    true_label =[true_label;-ones(size(samples_inx,1)-size(true_label,1),1)];
    
    predict = predicted_Y(samples_inx,column);
    right = sum(predict == true_label)/size(samples_inx,1);
    classifier_right = [classifier_right right];
end
end

function ECOC_cplx = get_ecoc_cplx(ECOC,DC_OPTION,TTD,TTL)
ECOC_cplx = [];
if strcmp(DC_OPTION,'N4') == 1 || strcmp(DC_OPTION,'L3') ==  1
    return;
end
for i = 1:size(ECOC,2)
    c1 = find(ECOC(:,i) == 1)
    c2 = find(ECOC(:,i) == -1)
    cplx = get_complexity_option(c1,c2,TTD,TTL,DC_OPTION);
    ECOC_cplx = [ECOC_cplx cplx];
end
end

function X = get_X(classifiers,data)
X = [];
for i=1:size(classifiers,1)
    x = predict(classifiers{i},data);
    X = [X x];
end

end
