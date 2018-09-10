function [l1,l2]=get_label1A2(c1,c2,train,label)
    l1=[];
    for i=1:size(c1)
        l1=[l1;label(find(label==c1(i)),:)];
    end
    l2=[];
    for i=1:size(c2)
        l2=[l2;label(find(label==c2(i)),:)];
    end    
end
