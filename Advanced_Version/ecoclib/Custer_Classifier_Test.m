%添加当前目录所有的m文件
addpath(genpath(pwd));
try
    load data_g.mat
catch
    error('Error: No training data');
end

%%自定义分类器和检测方法
clear Parameters;
Parameters.coding='OneVsOne';
Parameters.decoding='HD';
Parameters.base='MySVM'; 
Parameters.base_params='gaussian';
Parameters.base_test = 'MySVM_Test';

[Classifiers,Parameters]=ECOCTrain(data,labels,Parameters);
[Labels,Values,confusion]=ECOCTest(data,Classifiers,Parameters,labels);

%##########################################################################
%##########################################################################

clear Parameters;
Parameters.coding='Random';
Parameters.decoding='ED';
Parameters.base='NMC';
% Parameters.base_params.iterations=50; 
Parameters.base_test='NMCTest';
[Classifiers,Parameters]=ECOCTrain(data,labels,Parameters);
[Labels,Values,confusion]=ECOCTest(data,Classifiers,Parameters,labels);

