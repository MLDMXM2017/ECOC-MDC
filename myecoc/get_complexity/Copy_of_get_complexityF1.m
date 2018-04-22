% this function develop a solution by simulating variance of random samples
% in training datasets
function cplx = get_complexityF1(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    
    if size(data1,1) < 2
        global TD;
        glboal DL;
        [traindata1,~] = get_data1A2(c1,c2,TD,DL);
        if size(traindata1,1) < 2
            randtraindata1 = traindata1;
        else
            randnum = randperm(size(traindata1));
            randtraindata1 = traindata1(randnum(1:floor(size(traindata1,1)/3)));
        end
        data1 = randtraindata1;
    end
    
    
    if size(data2,1) < 2
        global TD;
        glboal DL;
        [~,traindata2] = get_data1A2(c1,c2,TD,DL);
        if size(traindata2,1) < 2
            randtraindata2 = traindata2;
        else
            randnum = randperm(size(traindata2));
            randtraindata2 = traindata2(randnum(1:floor(size(traindata2,1)/3)));
        end
        data2 = randtraindata2;
    end
    for p=1:size(train,2)
        fp(p)=(mean(data1(:,p))-mean(data2(:,p)))^2/(var(data1(:,p))+var(data2(:,p)));
    end
    clpx=max(fp);
%     cplx = median(fp);
end