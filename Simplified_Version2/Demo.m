%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is a simple demo of ECOC-MDC algorithm

%##########################################################################

%Step1. load all run files in the folder
addpath(genpath(pwd))
addpath(pwd)
disp(['current mat file path is:',pwd])

%Step2. define the input and output path
% define the input path
data_name = 'Breast';
train_data_path = './data/train_test/Breast_train_data.mat';
train_label_path = './data/train_test/Breast_train_label.mat';
test_data_path = './data/train_test/Breast_test_data.mat';
test_label_path = './data/train_test/Breast_test_label.mat';

% define the output path
save_path = './data/result';

% Step3. load the train and test data
load(train_data_path);
load(train_label_path);
load(test_data_path);
load(test_label_path);
if(isempty(TD)==true || isempty(TL)==true || isempty(TTD)==true || isempty(TTL)==true)
    error('Exit:load data error!');    
end

% Step4. set the parameters of ECOC training and start ECOC Train
% set parameters of ECOC learner
clear Params
Params.coding = 'ECOC_MDC';
Params.decoding = 'HD';
Params.base = 'SVM';
Params.base_test = 'SVM_Test';
Params.DC = 'Cluster';

% start ECOC training and test process
[Classifiers,Train_Params] = ECOCTrain(TD,TL,Params);
[Predict_label,~,Confusion] = ECOCTest(TTD,Classifiers,Train_Params,TTL);

clear result
result.Params = Train_Params;
result.Classifiers = Classifiers;
result.Predict_label = Predict_label;
result.Confusion = Confusion;
result.Evaluation = Fscore(TTL,Predict_label);

%Step5. save the result
matname=[save_path,'/',data_name,'_result.mat'];
save(matname,'result');

