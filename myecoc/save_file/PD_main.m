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

