function calculate_class_num(genpath,DS)
DS_names = {'Breast','Cancers','DLBCL','Leukemia1','Leukemia2','Lung'};
TL_num = {};
TTL_num = {};
for dataset_option = 1: size(DS,2) %dataset
    %获取原始数据
    [~,TL,~,TTL] = load_data([genpath,'/data/data_original/'],DS{dataset_option});
    TL_num{dataset_option,1} = get_num(TL);
    TTL_num{dataset_option,1} = get_num(TTL);
end%end of datanames
T = table(cell2mat(TL_num),cell2mat(TTL_num));
writetable(T,'E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\论文结果整理-期刊-pair\new_N3_F3\classes_num.xls','RowNames',DS_names);

end

function cnums = get_num(labels)
classes = unique(labels);
cnums = [];
for i = 1:size(classes,1)
    cnums(i) = sum(labels == classes(i));
end
end


