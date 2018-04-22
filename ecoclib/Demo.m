%添加当前目录所有的m文件
addpath(genpath(pwd));


try
    load data_g.mat
catch
    error('Error: No training data');
end

disp(' ');
disp('Calling the main ECOC function to train Glass data: one-versus-one coding, Hamming decoding, and Adaboost base classifier.');
disp('Parameters.coding="OneVsOne"');
disp('Parameters.decoding="HD"');
disp('Parameters.base="ADA"');
disp('Parameters.base_params.iterations=50');

clear Parameters;
Parameters.coding='OneVsOne';
Parameters.decoding='HD';
Parameters.base='MySVM';
Parameters.base_params.iterations=50;

disp('Press any key to continue'), pause

disp('[Classifiers,Parameters]=ECOCTrain(data,labels,Parameters)');
[Classifiers,Parameters]=ECOCTrain(data,labels,Parameters)

disp('Press any key to continue'), pause

disp(' ');
disp('Calling ECOCTest function to classify previous design over the same data:');

disp('Press any key to continue'), pause

disp('Parameters.base_test="ADAtest"');
Parameters.base_test='ADAtest';
disp('[Labels,Values,confusion]=ECOCTest(data,labels,Classifiers,Parameters)');
[Labels,Values,confusion]=ECOCTest(data,Classifiers,Parameters,labels)

disp('Press any key to continue'), pause

disp('Perform the same steps using a Sparse Random design with a Euclidean Decoding and Nearest Mean Classifier:');
disp('Parameters.coding="Random"');
disp('Parameters.decoding="ED"');
disp('Parameters.base="NMC"');

clear Parameters;
Parameters.coding='Random';
Parameters.decoding='ED';
Parameters.base='NMC';

disp('Press any key to continue'), pause

disp('[Classifiers,Parameters]=ECOCTrain(data,labels,Parameters)');
[Classifiers,Parameters]=ECOCTrain(data,labels,Parameters)

disp(' ');
disp('Calling ECOCTest function to classify previous design over the same data. No test labels are passed as parameters:');

disp('Press any key to continue'), pause

disp('Parameters.base_test="NMCTest"');
Parameters.base_test='NMCTest';
disp('[Labels,Values,confusion]=ECOCTest(data,labels,Classifiers,Parameters)');
[Labels,Values,confusion]=ECOCTest(data,Classifiers,Parameters,labels)

try
    load data_e.mat
    data(:,size(data,2)+1)=labels;
catch
    error('Error: No training data');
end

disp('Press any key to continue'), pause

disp('Calling the ECOCTrain function with Ecoli data, DECOC coding, Linear Loss-Weighted decoding, and Adaboost base classifier.');
disp('90% of the data is used to train:');
disp('Parameters.coding="DECOC"');
disp('Parameters.decoding="LLW"');
disp('Parameters.base="ADA"');
disp('Parameters.base_params.iterations=50');

clear Parameters;
Parameters.coding='DECOC';
Parameters.decoding='LLW';
Parameters.base='ADA';
Parameters.base_params.iterations=50;

disp('Press any key to continue'), pause

classes=unique(data(:,size(data,2)));
number_classes=length(classes);
dataTrain=[];
dataTest=[];
for i=1:number_classes
    positions=find(data(:,size(data,2))==classes(i));
    dataTrain=[dataTrain ; data(positions(1:floor(length(positions)*0.9)),:)];
    dataTest=[dataTest ; data(positions(floor(length(positions)*0.9))+1:end,:)];
end

disp('[Classifiers,Parameters]=ECOCTrain(dataTrain,labels,Parameters)');
[Classifiers,Parameters]=ECOCTrain(dataTrain(:,1:size(dataTrain,2)-1),dataTrain(:,size(dataTrain,2)),Parameters)

disp(' ');
disp('Calling ECOCTest function to classify previous design over remaining 10% of data:');

disp('Press any key to continue'), pause

disp('[Labels,Values,confusion]=ECOCTest(dataTest,labels,Classifiers,Parameters)');
disp('Parameters.base_test="ADAtest"');
Parameters.base_test='ADAtest';
[Labels,Values,confusion]=ECOCTest(dataTest(:,1:size(dataTest,2)-1),Classifiers,Parameters,dataTest(:,size(dataTest,2)))

disp('Press any key to continue'), pause

disp('Calling the ECOCTrain function with Iris data, ECOC-ONE coding, Exponential Loss-Weighted decoding, and Adaboost base classifier.');
disp('90% of the data is used to train:');
disp('Parameters.coding="ECOCONE"');
disp('Parameters.decoding="ELW"');
disp('Parameters.base="ADA"');
disp('Parameters.base_params.iterations=50');

clear Parameters;
Parameters.coding='ECOCONE';
Parameters.decoding='ELW';
Parameters.base='ADA';
Parameters.base_params.iterations=50;

disp('Press any key to continue'), pause

try
    load data_i.mat
    data(:,size(data,2)+1)=labels;
catch
    error('Error: No training data');
end

classes=unique(data(:,size(data,2)));
number_classes=length(classes);
dataTrain=[];
dataTest=[];
for i=1:number_classes
    positions=find(data(:,size(data,2))==classes(i));
    dataTrain=[dataTrain ; data(positions(1:floor(length(positions)*0.9)),:)];
    dataTest=[dataTest ; data(positions(floor(length(positions)*0.9))+1:end,:)];
end

disp('[Classifiers,Parameters]=ECOCTrain(dataTrain,labels,Parameters)');
disp('Parameters.base_test="ADAtest"');
Parameters.base_test='ADAtest';

[Classifiers,Parameters]=ECOCTrain(dataTrain(:,1:size(dataTrain,2)-1),dataTrain(:,size(dataTrain,2)),Parameters)

disp(' ');
disp('Calling ECOCTest function to classify previous design over remaining 10% of data:');

disp('Press any key to continue'), pause

disp('[Labels,Values,confusion]=ECOCTest(dataTest,labels,Classifiers,Parameters)');
[Labels,Values,confusion]=ECOCTest(dataTest(:,1:size(dataTest,2)-1),Classifiers,Parameters,dataTest(:,size(dataTest,2)))