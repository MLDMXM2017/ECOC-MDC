function save_mat(respath,classifier,dataname,dcplx,ica)
if isempty(dcplx) == 0
    dcplxpath = [respath,'/dcplx'];
    mkdir(dcplxpath);
    matname=[dcplxpath,'/dcplx_',classifier,'_',dataname,'.mat'];
    save(matname,'dcplx');
end

if isempty(ica) == 0
    icapath = [respath,'/ica'];
    mkdir(icapath);
    matname=[icapath,'/ica_',classifier,'_',dataname,'.mat'];
    save(matname,'ica');
end
end