function clpx=get_complexityF3(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    total=size(train,1);
    f=zeros([1,size(train,2)]);
    for p=1:size(train,2)
        count=0;
        m1=mean(data1(:,p));
        m2=mean(data2(:,p));
        if(m1>=m2)
            mn=min(data1(:,p));
            count=size(find(data2(:,p)>mn),1);
            mx=max(data2(:,p));
            count=count+size(find(data1(:,p)<mx),1);
        else
            mn=min(data2(:,p));
            count=size(find(data1(:,p)>mn),1);
            mx=max(data1(:,p));
            count=count+size(find(data2(:,p)<mx),1);
        end
        f(p)=1-count/total;
    end
    clpx=max(f);
end 
