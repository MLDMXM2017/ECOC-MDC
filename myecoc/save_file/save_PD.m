
function save_PD(PD,genpath)
    %生成文件夹
    pdpath = [genpath,'/pd'];
    mkdir(pdpath);
    
    %保存所有PD值
    value = [];
    datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'}; 
    for i = 1:size(datanames,2)
       temp = [];
       for j = 1:size(PD{i},2)
           for k = j+1:size(PD{i,2})
               temp(k,j) = PD(i,j,k);
               temp(j,k) = temp(k,j);
           end
       end
       if(size(temp,2)<size(value,2))
          column =zero(size(temp,1), size(value,2)-size(temp,2));
          temp = [temp column];       
       elseif(size(temp,2)>size(value,2) && isempty(value)==false)
          column =zero(size(value,1), size(temp,2)-size(value,2));
          value = [value column];
       end
          row = zeros([1,size(value,2)]);
          row(1,:) = -111111;
          value = [value;row;temp];          
    end   
    
    matname=[pdpath,'/PD.mat'];
    save(matname,'PD');
    
    csvwrite([pdpath,'/PD.csv'],value);
end