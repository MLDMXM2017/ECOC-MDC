train=td;
label=dl;
matrices=ica{9,7};
res={};
for j=1:size(matrices,2)
    codematrix=matrices{j};
    F1s=[];
    F2s=[];
    F3s=[];
    for i=1:size(codematrix,2)%ц©р╩ап
        m=codematrix(:,i);
        c1=find(m==1);
        c2=find(m==-1);
        F1s=[F1s get_complexityF1(c1,c2,train,label)];
        F2s=[F2s get_complexityF2(c1,c2,train,label)];
        F3s=[F3s get_complexityF3(c1,c2,train,label)];              
    end
    res{size(res,2)+1}={F1s,F2s,F3s};
end
ica{9,9}=[];

