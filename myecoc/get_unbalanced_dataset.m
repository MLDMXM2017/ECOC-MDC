
datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'}; 
path=['E:\mworkspace\ICDC-ECOC\res',num2str(1),'\'];
minr=1111111;
minindex=0;
for k=1:size(datanames,2)   

    [td,dl,testdata,data_test_label]=load_data(path,datanames{k});  

    r=[];
    d=[];
    for i=1:size(unique(dl),1)       
        d=[d size(find(dl==i),1)+size(find(data_test_label==i),1)];
        r=[r (size(find(dl==i),1)+size(find(data_test_label==i),1))/(size(dl,1)+size(data_test_label,1))];         
    end
    nowmin=min(r);
    if(nowmin<minr)
       minr=nowmin;
       minindex=k;
    end
    
end
fprintf('minr=%d----dataset=%s\n',minr,datanames{minindex});


