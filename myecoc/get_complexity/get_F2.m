%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成复杂度--F2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c1,c2,tcplx]=get_F2(c1,c2,train,label)
    disp('生成编码矩阵：F2');
    [c1,c2,tcplx]=F22(c1,c2,train,label);
end

%%第三种交换方式
function [c1,c2,tcplx]=F23(c1,c2,train,label)    
    cplx=get_complexityF2(c1,c2,train,label);
    tcplx=cplx;
    while(true)
        c1_s=c1;
        c2_s=c2;
        
        new_cplx = get_swap_group(c1,c2,train,label,'F2');
        
        if(new_cplx < cplx)
            c1=c1_nx;
            c2=c2_nx;
            cplx=new_cplx;
            tcplx=[tcplx cplx];          
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end  
    end
end      

function [c1,c2,tcplx]=F22(c1,c2,train,label)
% 第二种交换方式
    cplx=get_complexityF2(c1,c2,train,label);
    tcplx=cplx;
    dsign='F2';
    draw_pic(c1,c2,train,label,dsign);
    global picnum;
    dsign=['F2_',num2str(picnum),'_local'];
    while(true)
        c1_s=c1;
        c2_s=c2;

        lagerm=get_larger(c1,c2,train,label);
        if(lagerm==1)
            cmini=get_minavg(c1,train,label);
            cmaxi=get_maxavg(c2,train,label);
            [c1_xn,c2_xn]=swap(c1,c2,cmini,cmaxi);            
        elseif(res==2)
            cmini=get_minavg(c2,train,label);    
            cmaxi=get_maxavg(c1,train,label);                
            [c1_xn,c2_xn]=swap(c1,c2,cmaxi,cini);
        end
        xncplx=get_complexityF2(c1_xn,c2_xn,train,label);

        % % %select max between xncplx and nxcplx
        if(xncplx<cplx)
            c1=c1_xn;
            c2=c2_xn;
            cplx=xncplx;
            tcplx=[tcplx cplx];  
            draw_pic(c1,c2,train,label,dsign);
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end        
% % % % % % % % % % % % % % % % % % % % % % % % %       
    end    
end

%第一种交换方式
function [c1,c2,tcplx]=F21(c1,c2,train,label)    
    cplx=get_complexityF2(c1,c2,train,label);
    tcplx=cplx;
    while(true)
        c1_s=c1;
        c2_s=c2;
        % %   swap min max       
        c1i=get_minavg(c1,train,label);
        c2i=get_minavg(c2,train,label);
        [c1_nx,c2_nx]=swap(c1,c2,c1i,c2i);

        nxcplx=get_complexityF2(c1_nx,c2_nx,train,label);

        % % %  swap max min
        c1i=get_maxavg(c1,train,label);
        c2i=get_maxavg(c2,train,label);        
        [c1_xn,c2_xn]=swap(c1,c2,c1i,c2i);
        xncplx=get_complexityF2(c1_xn,c2_xn,train,label);
        
        if(nxcplx<=xncplx &&nxcplx<cplx)
            c1=c1_nx;
            c2=c2_nx;
            cplx=nxcplx;
            tcplx=[tcplx cplx];     
        elseif(xncplx<=nxcplx &&xncplx<cplx)
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


 
% % % % % % % % % % % % % % % % % % % % % % % % 
function res=get_larger(c1,c2,train,label)
    % % %计算每个feature均值和 
    [data1,data2]=get_data1A2(c1,c2,train,label);
    for p=1:size(train,2)
        m1(p)=mean(data1(:,p));
        m2(p)=mean(data1(:,p));
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


function F2=get_complexityF2(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    F2=0;
    for p=1:size(train,2) 
       M=min(max(data1(:,p),max(data2(:,p))))-max(min(data1(:,p)),min(data2(:,p) ));
       D=max(max(data1(:,p),max(data2(:,p))))-min(min(data1(:,p)),min(data2(:,p) ));
       F2=F2+(M/D);
    end     
end 

function index=get_minavg(c,train,label)
    % % %计算具有最小feature的类别
    maxvalue=1.7977e+308;
    index=0;
    bb_m=maxvalue;
    for i=1:size(c,1)
        
        b_m=maxvalue;
        for j=1:size(train,2)            
            m=min(train(find(label==c(i)),j));
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
        error('Exit:get min avg error');
    end
    
end


function index=get_maxavg(c,train,label)
    % % %计算具有最大feature的类别
    minvalue=-1.7977e+308;
    index=0;
    bb_m=minvalue;
    for i=1:size(c)  
        
        b_m=minvalue;        
        for j=1:size(train,2)           
            m=max(train(find(label==c(i)),j));
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