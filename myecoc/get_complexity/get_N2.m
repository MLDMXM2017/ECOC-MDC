%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成复杂度--N2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c1,c2,tcplx]=get_N2(c1,c2,train,label)
    cplx=get_complexityN2(c1,c2,train,label);
    tcplx=cplx;
    
    disp('生成编码矩阵：N2');
    
    while(true)
        % % %   swap min max
        c1_s=c1;
        c2_s=c2;
       
        c1mx=get_maxdis(c1,c2,train,label);
        c2mx=get_maxdis(c2,c1,train,label);
        
        if(c1mx==0 | c2mx==0)
            error('Exit:get max error!')
        end
        
        [c1_xx,c2_xx]=swap(c1,c2,c1mx,c2mx);
        xxcplx=get_complexityN2(c1_xx,c2_xx,train,label);
    
        if(xxcplx<cplx)
            c1=c1_xx;
            c2=c2_xx;
            cplx=xxcplx;    
            tcplx=[tcplx cplx];
            draw_pic(c1,c2,train,label,dsign);
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end        
    end    

end

function clpx=get_complexityN2(c1,c2,train,label)
    tintra=0;
    tinter=0;
    [data1,data2]=get_data1A2(c1,c2,train,label);
    [label1,label2]=get_label1A2(c1,c2,train,label);
    data=[data1;data2];
    label=[label1;label2];
 
    % % %计算每个点的最近类间距离和最近类内距离
    for i=1:size(data,1)
        dis1=get_dis(data(i,:),data1,data);
        dis2=get_dis(data(i,:),data2,data);
        
        l=label(i);
        if(isempty(find(c1==l))~=1) 
           tintra=tintra+dis1;
           tinter=tinter+dis2;         
        elseif(isempty(find(c2==l))~=1)
           tintra=tintra+dis2;
           tinter=tinter+dis1;
        else
           error('Exit:not found label');
        end
    end    
    
    % % %计算复杂度
    clpx=tintra/tinter;  
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


% function index=get_maxdis(c,train,label,option)
%     index=0;
%     tm=zeros([1,size(c,1)]);
%     for i=1:size(c,1)
%         m=0;
%         for p=1:size(train,2)
%             m=m+mean(train(find(label==c(i)),p));
%         end
%         tm(i)=mean(m);
%     end
%     tdis=zeros([1,size(c,1)]);
%     for i=1:size(c,1)
%         tdis(i)=0;
%         for j=i+1:size(c,1)
%             tdis(i)=tdis(i)+abs(tm(i)-tm(j));
%         end
%     end
%     
%     if(strcmp(option,'max')==1)
%         index=find(tdis==max(tdis));
%     elseif(strcmp(option,'min')==1)
%         index=find(tdis==min(tdis));
%     end
%     if(size(index,2)>1)
%         index=index(1);
%     end
%     
% end

function index=get_maxdis(c1,c2,train,label)
    % % %找到c1 c2类的样本点
    index=0;
    mc1=get_meanp(c1,train,label);%平均样本点集合
    mc2=get_meanp(c2,train,label);
    
    for i=1:size(mc1,1)%样本点中的每个点
        intradis=get_dis(mc1(i,:),mc1,train);
        interdis=get_dis(mc1(i,:),mc2,train);
        ratio(i)=intradis/interdis;        
    end
    index=find(ratio==max(ratio));    
%     
%     % % %计算c1类的样本点的类内距离
%     tdis=zeros([size(c1,1),size(c1,1)]);
%     for i=1:size(c1,1)
%         for j=i+1:size(c1,1)
%             tdis(i,j)=get_ppdis(c1(i,:),c1(j,:));
%             tdis(j,i)=tdis(i,j);
%         end
%     end    
%     % % %计算每个类的样本点的距离和
%     for i=1:size(c1,1)
%         ttdis(i)=sum(tdis(i,:));
%     end
%     
%     % % %找到最大距离的样本点的坐标
%     index=find(ttdis==max(ttdis));
%     if(size(index,2)>1)
%         index=index(1);
%     end
end
function mc=get_meanp(c,train,label)
    for i=1:size(c,1)
        for p=1:size(train,2)
           mp(p)=mean(train(find(label==c(i)),p)); 
        end
        mc(i,:)=mp;
    end
end

function dis=get_ppdis(p1,p2)
    dis=0;
    for i=1:size(p1,2)
        dis=dis+(p1(1,i)-p2(1,i))^2;
    end
    dis=sqrt(dis);    
end


function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
end
