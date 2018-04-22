%返回的是矩阵的平均值
function cplx_sum = get_ecoc_cplx_sum(ecocs,td,dl,dc_name)
cplx_sum = zeros(1,size(ecocs,2));
for e = 1:size(ecocs,2)%每个矩阵
    each_ecoc = ecocs{1,e};
    for column = 1:size(each_ecoc,2)
        c11 = find(each_ecoc(:,column)==1);
        c12 = find(each_ecoc(:,column)==-1);
        cplx_sum(e) = cplx_sum(e) + get_complexity_option(c11,c12,td,dl,dc_name);
    end
    cplx_sum(e) = cplx_sum(e)/size(each_ecoc,2);
end
end