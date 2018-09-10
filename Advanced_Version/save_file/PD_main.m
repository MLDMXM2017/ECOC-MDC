function PD_main()
datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'};
genpath = 'E:\桌面\ecoc\ecoc-2.23\ICDC-ECOC\ICDC-ECOC\res1\0223结果';


%保存所有PD值
value = [];
for i = 1:size(datanames,2)
    PD = {};
    path = [genpath,'\coding\dcplx_discriminant',datanames{i},'.mat'];
    load(path);
    allm = dcplx{i,7};
    for j = 1:size(allm,2)
        for k = j+1:size(allm,2)
            PD{j,k} = get_PD(allm{1,j},allm{1,k});
        end
    end
    
    if(size(PD,2)<size(value,2))
        column =zero(size(PD,1), size(value,2)-size(PD,2));
        PD = [PD column];
    elseif(size(PD,2)>size(value,2) && isempty(value)==false)
        column =zero(size(value,1), size(PD,2)-size(value,2));
        value = [value column];
    end
    row = zeros([1,size(PD,2)]);
    row(1,:) = -111111;
    value = [value;PD];
end

%生成文件夹
pdpath = [genpath,'/pd'];
mkdir(pdpath);

matname=[pdpath,'/PD.mat'];
save(matname,'value');

%csvwrite([pdpath,'/PD.csv'],value);
end


function PD = get_PD(M1,M2)
index = find(M1==-1);
M1(index) = 2;
index = find(M2==-1);
M2(index) = 2;

len1 = size(M1,2);
len2 = size(M2,2);
PD = 0;
for i = 1:len1%M1 i row
    minvalue = 111111;
    for j = 1:len2%M2 j row
        nowvalue = 0;
        if(size(M1,1) < size(M2,1))
            minlen = size(M1,1);
            maxlen = size(M2,1);
        else
            minlen = size(M2,1);
            maxlen = size(M1,1);
        end
        for k = 1:size(minlen,1)%M1 M2 k bit
            nowvalue = nowvalue + bitxor(M1(k,i),M2(k,j));%位异或函数
        end
        if(size(M1,1) ~= size(M2,1))
            nowvalue = nowvalue + abs(size(M1,1) - size(M2,1));
        end
        if(nowvalue < minvalue)
            minvalue = nowvalue;
        end
    end
    PD = PD + minvalue;
end
end

