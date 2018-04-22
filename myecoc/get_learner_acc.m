 filepath=['E:\mworkspace\ICDC-ECOC\res',num2str(1),'\1209结果\'];
 
 datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'}; 
 learners={'discriminant','knn','naivebayes','svm','tree','NMC','ADA'};
 

 for i=1:size(learners,2)
     tacc=[];
     tspc=[];
     tsen=[];
     tfscore=[];
     tpre=[];
     for j=1:size(datanames,2)          
         dcplxfile=[filepath,'dcplx\dcplx_',learners{i},datanames{j},'.mat'];
         icafile=[filepath,'ica\ica_',learners{i},datanames{j},'.mat'];
         load(dcplxfile);
         load(icafile);        
         [acc,spc,sen,pre,fscore]=get_dataset_fscore(dcplx{j,2},ica{j,2});   
          tacc=[tacc;acc];
          tspc=[tspc;spc];
          tsen=[tsen;sen];
          tpre=[tpre;pre];
          tfscore=[tfscore;fscore];       
     end     
     temp=zeros([1,size(tacc,2)]);
     temp(1,:)=-11111;
     res=[tacc;temp;tspc;temp;tsen;temp;tpre;temp;tfscore];     
     csvwrite([filepath,'分类器汇总结果_',learners{i},'.csv'],res);  
 end
 
