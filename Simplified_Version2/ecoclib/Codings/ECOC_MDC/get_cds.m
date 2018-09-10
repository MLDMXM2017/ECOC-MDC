%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% This file is to generate the coding matrix of ECOC-MDC

%##########################################################################
function [cds,cplx]=get_cds(td,dl,total_cls_num,dc_option)
    % coding matrix
    class = (1:total_cls_num)';
    cds=zeros([total_cls_num,total_cls_num]);
    global gcount;
    gcount=0;
    [cds,cplx] = coding(class,td,dl,cds,{},total_cls_num,dc_option);
    % drop out the extra zero columns
    temp = [];
    for i =1:size(cds,2)
        if(any(cds(:,i)~=0))
            temp = [temp,cds(:,i)];
        end
    end
    cds = temp;   
end

% this function is to coding single columns of coding matrix of ECOC-MDC
function [cds,fcplx]=coding(class,traindata,trainlabel,cds,fcplx,total_cls_num,option) 
    global gcount;
    s=floor(size(class)/2);
    t=size(class);
    c1=class(1:s,:);
    c2=class(s+1:t,:);
    if(size(c1,1)==0 | size(c2,1)==0)
        error('Exit:group c contains no subclass!');    
    else
        try
            [c11,c12,tcplx] = feval(['get_',option],c1,c2,traindata,trainlabel);  
        catch 
            error('Exit:DC option is wrong in the encoding of ECOC-MDC!')
        end
    end   
    
    % classes in c1 group are positive(+1)
    % classes in c2 group are negative(-1)
    code=zeros([total_cls_num,1]);
    code(c11)=1;
    code(c12)=-1;
    gcount=gcount+1;
    cds(:,gcount)=code;
    fcplx{gcount}=tcplx;
   
    % if any group in c1 group or c2 group has more than one classes, the
    % encoding process continues
    if(size(c11,1)>=2)       
        [cds,fcplx]=coding(c11,traindata,trainlabel,cds,fcplx,total_cls_num,option);   
    end

    if(size(c12,1)>=2)        
        [cds,fcplx]=coding(c12,traindata,trainlabel,cds,fcplx,total_cls_num,option); 
    end
end  
        