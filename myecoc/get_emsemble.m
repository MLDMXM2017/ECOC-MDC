%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 将F1-F3生成的矩阵的矩阵融合
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function em_cds=get_emsemble(cds1,cds2,cds3)
    em_cds = (unique([cds1,cds2,cds3]','rows'))';
end


