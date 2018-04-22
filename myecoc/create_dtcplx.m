%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 加载数据生成复杂度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tdcplx = create_dtcplx(genpath,learnername,datanames)

    tdcplx = {};
    for i=1:size(datanames,2)        
        matname = [genpath,'\dcplx_',learnername,'_',datanames{i},'.mat'];
        load(matname);
        position = size(dcplx,1);
        tdcplx{i,1}=datanames{i};
        tdcplx{i,2}=dcplx{position,6};
    end
end