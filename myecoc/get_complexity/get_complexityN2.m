function cplx=get_complexityN2(c1,c2,train,label)
    tintra=0;
    tinter=0;
    [data1,data2]=get_data1A2(c1,c2,train,label);
    [label1,label2]=get_label1A2(c1,c2,train,label);
    data=[data1;data2];
    label=[label1;label2];
 
    % % %计算每个点的最近类间距离和最近类内距离
    for i=1:size(data,1)
        dis1=get_dis(data(i,:),data1,data);%类内最近距离
        dis2=get_dis(data(i,:),data2,data);%类外最近距离
        
        l=label(i);
        if(isempty(find(c1==l))~=1)%是group1的样本 
           tintra=tintra+dis1;
           tinter=tinter+dis2;         
        elseif(isempty(find(c2==l))~=1)%是group2的样本
           tintra=tintra+dis2;
           tinter=tinter+dis1;
        else
           error('Exit:not found label');
        end
    end        
       
    % % %计算复杂度
    cplx=tintra/tinter;  
    %这里应该补充分子分母为0的情况
    if cplx == inf
        pause(1000);
    end
end

function dis=get_dis(point,data,train)
    dis=1.7977e+308;
    for i=1:size(data,1)
        if(isequal(data(i,:),point)) %重合点
            continue;
        end
        pdis=0;
        for p=1:size(train,2)
            pdis=pdis+(data(i,p)-point(p))^2;
        end
        if(sqrt(pdis)<dis)
            dis=sqrt(pdis);
        end
    end    
end