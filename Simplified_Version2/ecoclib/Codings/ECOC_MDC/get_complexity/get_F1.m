%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is part of ECOC-MDC
% this file is to generate two groups based on F1 DC measure
% The related intorduction are shown in the paper
% <Analysis of data complexity measures for classification>

%##########################################################################

function [c1,c2,tcplx]=get_F1(c1,c2,train,label)    
    disp('split class based on the F1 measure');
    cplx=get_complexityF1(c1,c2,train,label);  
    tcplx=cplx;
     
    while(true)       
        c1_s=c1;
        c2_s=c2;        
        
        % swap maximum class in first group with minimum class in second group
        cmini=get_minavg(c1,train,label);
        cmaxi=get_maxavg(c2,train,label);
        [c1_nx,c2_nx]=swap(c1,c2,cmini,cmaxi);

        nxcplx=get_complexityF1(c1_nx,c2_nx,train,label);

        % swap minimum class in first group with maximum class in second group
        cmaxi=get_maxavg(c1,train,label);
        cmini=get_minavg(c2,train,label);        
        [c1_xn,c2_xn]=swap(c1,c2,cmaxi,cmini);

        xncplx=get_complexityF1(c1_xn,c2_xn,train,label);

        % % %select max between xncplx and nxcplx
        if(xncplx>=nxcplx && xncplx>cplx)
            c1=c1_xn;
            c2=c2_xn;
            cplx=xncplx;
            tcplx=[tcplx cplx];   

        elseif(nxcplx>=xncplx && nxcplx>cplx)
            c1=c1_nx;
            c2=c2_nx;
            cplx=nxcplx;
            tcplx=[tcplx cplx];  
            
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end        
    end
end

function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
end

function clpx=get_complexityF1(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    for p=1:size(train,2)
        fp(p)=(mean(data1(:,p)-mean(data2(:,p)))^2/(var(data1(:,p))+var(data2(:,p))));
    end
    clpx=max(fp);       
end

function index=get_minavg(c,train,label)
    % obtain the class with minimum mean sample value
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
    % obtain the class with maximum mean sample value
    minvalue=-1.7977e+308;
    index=0;
    bb_m=minvalue;
    for i=1:size(c,1) 
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
        error('Exit:get max avg error');
    end    
end