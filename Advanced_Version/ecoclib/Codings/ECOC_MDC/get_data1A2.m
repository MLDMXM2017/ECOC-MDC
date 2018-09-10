function [data1,data2]=get_data1A2(c1,c2,train,label)
    data1=[];
    for i=1:size(c1)
        data1=[data1;train(find(label==c1(i)),:)];
    end
    data2=[];
    for i=1:size(c2)
        data2=[data2;train(find(label==c2(i)),:)];
    end    
end
