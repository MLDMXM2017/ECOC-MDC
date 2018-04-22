function [adjusted_c1,adjusted_c2] = get_swap_group(c1,c2,train,label,DC_OPTION)
    [subclass_c1,sbuclass_c2] = select_adjusted_class(c1,c2,train,label,DC_OPTION);
    [adjusted_c1,adjusted_c2]=swap_class(c1,c2,subclass_c1,sbuclass_c2);   
end

function [adjusted_c1,adjusted_c2] = select_adjusted_class(c1,c2,train,label,DC_OPTION)
    %计算m-1对的复杂度值
    group = [c1',c2'];
    res = zeros([max(group) max(group)]);
    for i = 1:size(group,2)
        for j=i+1:size(group,2)
           res(group(i),group(j)) = get_complexity_option(group(i),group(j),train,label,DC_OPTION);
           res(group(j),group(i)) = res(group(i),group(j));
        end
    end
    
    %计算每个类的复杂度和的均值
    ressum = zeros(1,max(group));
    res = res/(size(group,2)-1);
    for i = 1:size(res,2)
       ressum(i) = sum(res(i,:)); 
    end
    
    %挑选复杂度最大的两个类
    ressum1 = ressum(c1);
    ressum2 = ressum(c2);
    adjusted_c1 = c1(find( ressum1 == max(ressum1)));
    adjusted_c2 = c2(find( ressum2 == max(ressum2)));
    
    
    %如果复杂度最大的类存在多个，只选择第一个
    if(size(adjusted_c1,2) ~= 1 || size(adjusted_c1,1) ~=1)
        adjusted_c1 = adjusted_c1(1);
    end
    
    if(size(adjusted_c2,2) ~= 1 || size(adjusted_c2,1) ~=1)
        adjusted_c2 = adjusted_c2(2);
    end   

end

function [c1,c2] = swap_class(c1,c2,swap_1,swap_2)
    index1 = find(c1 == swap_1);
    index2 = find(c2 == swap_2);
    c1(index1) = swap_2;
    c2(index2) = swap_1;
   
end