%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 计算codematrix的长度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nums=get_number(data)
    nums=[];
    for i=1:size(data,2)
        d=data{i};
        nums=[nums size(d,2)];        
    end
end
