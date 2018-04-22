function [cplx,clusterlabel,clabel]=get_complexityCluster(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    center1=get_center(data1);%¾ùÖµ
    center2=get_center(data2);

    data=[data1;data2];
    for i=1:size(data,1)
        dis1=get_pp_dis(data(i,:),center1);
        dis2=get_pp_dis(data(i,:),center2);
        if(dis1>dis2)
            clusterlabel(i)=2;
        else
            clusterlabel(i)=1;
        end        
    end

    clabel=ones([1,size(data,1)]);
    clabel(1,size(data1,1)+1:size(data,1))=2;    
    cplx=(sum(clabel~=clusterlabel))/size(data,1);
    
end

function center=get_center(data)
    for p=1:size(data,2) %group
       center(p)=mean(data(:,p));        
    end
end

function dis=get_pp_dis(p1,p2)
    dis=0;
    for p=1:size(p1,2)
        dis=dis+(p1(1,p)-p2(1,p))^2;
    end
    dis=sqrt(dis);
end