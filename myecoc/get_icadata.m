function [td,dl,testdata,data_test_label]=get_icadata(data_train,data_train_label,data_test,data_test_label)

    traindata=data_train;
    ZTN=data_train_label;
    
    testdata=data_test;
    ZTT=data_test_label;    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % train预处理 
    tndata=remmean(traindata');%去均值处理
    stdvtn=std(tndata',1);%计算标准偏差
    X=tndata./repmat(stdvtn',1,size(tndata,2));   %%%% mean=0
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % test预处理 
    ttdata=remmean(testdata');
    stdvtt=std(ttdata',1);
    XT=ttdata./repmat(stdvtt',1,size(ttdata,2));   %%%% variance=1  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %ICA变换
    theta=[-1,1]';
    size_of_microarry=size(ZTN,1);%label的个数
%     size_of_microarry=80;
    srcnb=size_of_microarry;%独立分量个数
    red=size_of_microarry;   %特征值的个数
    app='symm';%并行估计所有成分
    NL='tanh';%固定点算法中使用的非线性函数
    stab='off';%是否进行稳定化
% % % verbose%是否用文本输出算法进展
% % % displayMode是否画出算法进展情况
    nbsimul=1;%迭代次数
    eigenarray={};
    A={};
    W={};
    for i=1:nbsimul
        [eigenarray{i},A{i}, W{i}] =fastica(X,'firstEig',1,'lastEig', red, 'numOfIC', srcnb, 'g', NL, 'approach', app, 'stabilization',...
            stab, 'verbose', 'off','displayMode','off');
    end       
    eigenarray=eigenarray{1};  
    testdata=XT/eigenarray;     
    
    % % % 获取数据
    td=A{1};
    dl=data_train_label;  
    

end