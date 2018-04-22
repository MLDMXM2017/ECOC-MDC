%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成复杂度--聚类
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c1,c2,tcplx]=get_Cluster(c1,c2,train,label) 
    disp('生成编码矩阵：Cluster');
    tcplx=[];
    [cplx,clusterlabel,clabel]=get_complexityCluster(c1,c2,train,label);
    tcplx=cplx;
    count=size(c1,1)+size(c2,1);%设置迭代次数
    while(true)       
        
        [c11,c21]=get_index(c1,c2,clusterlabel,clabel,train,label);
        if(isequal(c11,c1)==true & isequal(c21,c2)==true)
            break;
        else           
            newcplx=get_complexityCluster(c11,c21,train,label);
            if(newcplx<cplx)
                cplx=newcplx;
                tcplx=[tcplx cplx];
                c1=c11;
                c2=c21;
            else
                break;
            end
        end        
    end    
end

function [cplx,clusterlabel,clabel]=get_complexityCluster(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    center1=get_center(data1);%均值
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

function [c1,c2]=get_index(c1,c2,clusterlabel,clabel,train,label)
    [label1,label2]=get_label1A2(c1,c2,train,label);
    datalabel=[label1;label2];
    count=zeros([size(unique(label),1),1]);%所有的label的集合
    for i=1:size(clusterlabel,2)
       if(clabel(i)~=clusterlabel(i))
           count(datalabel(i,1))=count(datalabel(i,1))+1;%本身的label识别错误数量增加1
       end
    end
    if((sum(count)/size(datalabel,1))>0.05)
        index1=find(count(c1)==max(count(c1)));
        index2=find(count(c2)==max(count(c2)));   
        if(size(index1,1)>1) index1=index1(1); end%label1
        if(size(index2,1)>1) index2=index2(1); end%label2
        [c1,c2]=swap(c1,c2,index1,index2);
    end
end


function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
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