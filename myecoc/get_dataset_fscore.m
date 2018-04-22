 function [acc,spc,sen,pre,fscore]=acc(dcplx,ica)   
    acc=[];
    spc=[];
    sen=[];
    fscore=[];
    pre=[];
    for i=1:size(dcplx,2)%有几种方法：F1，F2...Cluster
        values=dcplx{i};
        acc=[acc values(1)];
        sen=[sen values(2)];
        spc=[spc values(3)];
        pre=[pre values(4)];
        fscore=[fscore values(5)];        
    end
    for i=1:size(ica,2)%有几种方法：random, ovo....
        values=ica{i};
        acc=[acc values(1)];
        sen=[sen values(2)];
        spc=[spc values(3)];
        pre=[pre values(4)];
        fscore=[fscore values(5)];              
    end
 end