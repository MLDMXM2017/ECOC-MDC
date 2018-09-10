function SVMModel = MySVM(data1,data2,kernel_param)
    data = [data1;data2];
    label = [ones(size(data1,1),1); -ones(size(data2,1),1)];
    SVMModel = fitcsvm(data,label,'KernelFunction',kernel_param);
end