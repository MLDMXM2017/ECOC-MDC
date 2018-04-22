function F2=get_complexityF2(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    F2=0;
    for p=1:size(train,2) 
       M=min(max(data1(:,p),max(data2(:,p))))-max(min(data1(:,p)),min(data2(:,p)));
       D=max(max(data1(:,p),max(data2(:,p))))-min(min(data1(:,p)),min(data2(:,p) ));
       F2=F2+(M/D);
    end     
end