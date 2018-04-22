%得到所有的复杂度
function [c1,c2,tcplx]=get_complexity(c1,c2,train,label,DC_OPTION)
    cplx=get_complexity_option(c1,c2,train,label,DC_OPTION);
    tcplx=cplx;
    while(true)
        pre_c1=c1;
        pre_c2=c2;

        [adjusted_c1,adjusted_c2] = get_swap_group(c1,c2,train,label,DC_OPTION);
        new_cplx=get_complexity_option(adjusted_c1,adjusted_c2,train,label,DC_OPTION);
        
        flag = 0;%0表示不进行交换 1表示进行交换
        if(is_contains(DC_OPTION) == true)
            if(new_cplx > cplx)
               flag = 1;
            end
        else
            if(new_cplx < cplx)
               flag = 1;
            end
        end
        if(flag==1)
            c1=adjusted_c1;
            c2=adjusted_c2;
            cplx=new_cplx;
            tcplx=[tcplx cplx];
        else
            c1=pre_c1;
            c2=pre_c2;
            break;
        end
    end
end

function res = is_contains(str)
    strings = {'F1','F3'};
    res = false;
    for i = 1:size(strings,2)
        if(strcmp(strings{i},str) == 1)
            res = true;
            break;
        end
    end
end