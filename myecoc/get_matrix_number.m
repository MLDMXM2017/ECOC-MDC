
datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','Lung2','SRBCT'}; 
path1='E:\桌面\挑选后的数据\dcplx\';
path2='E:\桌面\挑选后的数据\ica\';
nums=[];
for i=1:size(datanames,2)   
   dcplxpath=[path1,'dcplx_discriminant',datanames{i},'.mat'];
   icapath=[path2,'ica_discriminant',datanames{i},'.mat'];

   load(dcplxpath);
   load(icapath);

   new_row=get_number(dcplx{i,7});
   new_row=[new_row get_number(ica{i,7})];
   nums=[nums;new_row];
end


