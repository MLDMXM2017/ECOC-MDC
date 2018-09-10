%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is part of ECOC-MDC
% this file is to generate two groups based on F3 DC measure
% The related intorduction are shown in the paper
% <Analysis of data complexity measures for classification>

%##########################################################################
function  [c1,c2,tcplx]=get_F3(c1,c2,train,label)
    disp('split class based on the F3 measure');
    cplx=get_complexityF3(c1,c2,train,label);
    tcplx=cplx;
  
    while(true)
        c1_s=c1;
        c2_s=c2;
        
        lagerm=get_larger(c1,c2,train,label);
        if(lagerm==1)
            cmini=get_minavg(c1,train,label);
            cmaxi=get_maxavg(c2,train,label);
            [c1_xn,c2_xn]=swap(c1,c2,cmini,cmaxi);           
        elseif(lagerm==2)
            cmini=get_minavg(c2,train,label);    
            cmaxi=get_maxavg(c1,train,label);                
            [c1_xn,c2_xn]=swap(c1,c2,cmaxi,cmini);
        end
            xncplx=get_complexityF3(c1_xn,c2_xn,train,label);       
        if(xncplx>cplx)
            c1=c1_xn;
            c2=c2_xn;
            cplx=xncplx;   
            tcplx=[tcplx cplx];
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end        
    end
end

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

function res=get_larger(c1,c2,train,label)
    % calculate the mean value of samples
    [data1,data2]=get_data1A2(c1,c2,train,label);
    for p=1:size(train,2)
        m1(p)=mean(data1(:,p));
        m2(p)=mean(data2(:,p));
    end
    res=m1-m2;
    if(sum(res)>=0) res=1;
    else res=2; end
end

function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
end


function index=get_minavg(c,train,label)
    maxvalue=1.7977e+308;
    index=0;
    bb_m=maxvalue;
    for i=1:size(c,1)
        
        b_m=maxvalue;
        for j=1:size(train,2)            
            m=mean(train(find(label==c(i)),j));
            if(m<b_m)
                b_m=m;
            end
        end
        if(b_m<bb_m)
            bb_m=b_m;
            index=i;
        end
    end  
    
    if(index==0)
        error('get min avg error');
    end
    
end


function index=get_maxavg(c,train,label)
    minvalue=-1.7977e+308;
    index=0;
    bb_m=minvalue;
    for i=1:size(c)  
        
        b_m=minvalue;        
        for j=1:size(train,2)           
            m=mean(train(find(label==c(i)),j));
            if(m>b_m)
                b_m=m;
            end
        end
        
        if(b_m>bb_m)
            bb_m=b_m;
            index=i;
        end
    end   
    if(index==0)
        error('get max avg error');
    end
    
end
            
        