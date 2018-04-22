%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成所有codematrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tcds,tcplx]=get_all_cds(total_cls_num,td,dl,option)
    options={'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
    %options={'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster';'ACC';'AD-F1';'W-F1'};
    if(strcmp('ALL',option)==1)
        for o=1:size(options,1)
            [cds,cplx]=get_cds(td,dl,total_cls_num,o);
            tcplx{o}=cplx;
            tcds{o}=cds;
        end
    else
        for o=1:size(options,1)
            if(strcmp(option,options{o})==1)
                [cds,cplx]=get_cds(td,dl,total_cls_num,o);
                tcplx{1}=cplx;
                tcds{1}=cds;
                break;
            end
        end
    end
    
end
function [cds,cplx]=get_cds(td,dl,total_cls_num,o)
    options={'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
    %options={'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster';'ACC';'AD-F1';'W-F1'};
    
   % % % coding matrix
    class = (1:total_cls_num)';
    cds=zeros([total_cls_num,total_cls_num]);
    global gcount;
    gcount=0;
    
    if(strcmp(options{o},'AD-F1') == 1)
        global cplx_class;
        cplx_class = [];
        [old_cds,old_cplx] = coding(class,td,dl,cds,{},total_cls_num,options{o});  
        if(isempty(cplx_class) == false)
            [new_cds,new_cplx] = coding(cplx_class',td,dl,cds,{},total_cls_num,options{o});  
            cds = [old_cds new_cds];
            cplx = [old_cplx new_cplx];   
        else
            cds = old_cds;
            cplx = old_cplx;
        end
    
    elseif(strcmp(options{o},'W-F1') == 1)
        %初始权重值
        global weight;
        weight = zeros([1 size(unique(dl),2)]);
        [cds,cplx] = coding(class,td,dl,cds,{},total_cls_num,options{o});
        
    else 
        [cds,cplx] = coding(class,td,dl,cds,{},total_cls_num,options{o});   
    end
    
    % % 去除多余的0列
    temp = [];
    for i =1:size(cds,2)
        if(any(cds(:,i)~=0))
            temp = [temp,cds(:,i)];
        end
    end
    cds = temp;
   
end