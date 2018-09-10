%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is part of ECOC-MDC
% this file is to generate two groups based on N2 DC measure
% The related intorduction are shown in the paper
% <Analysis of data complexity measures for classification>

%##########################################################################
function [c1,c2,tcplx]=get_N2(c1,c2,train,label)
    disp('split class based on the N2 measure');
    
    cplx=get_complexityN2(c1,c2,train,label);
    tcplx=cplx;
    while(true)
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
 
    % calculate the cloestest innter-distance and intra-distance
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
    
    clpx=tintra/tinter;  
end

function dis=get_dis(point,data,train)
    dis=1.7977e+308;
    for i=1:size(data,1)
        if(isequal(data(i,:),point)) %overlapping points
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

function index=get_maxdis(c1,c2,train,label)
    % find the centroids of group1 and group2
    index=0;
    mc1=get_meanp(c1,train,label);
    mc2=get_meanp(c2,train,label);
    
    for i=1:size(mc1,1)
        intradis=get_dis(mc1(i,:),mc1,train);
        interdis=get_dis(mc1(i,:),mc2,train);
        ratio(i)=intradis/interdis;        
    end
    index=find(ratio==max(ratio));   
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
