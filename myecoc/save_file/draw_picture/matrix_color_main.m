%% http://www.matlabsky.com/thread-32849-1-1.html
% 根据实值矩阵绘制色块图，以下为测试代码。
x = [];
dc_names = {'F1','F2','F3','N2','N3','C1'};
data_titles={'C1','N3','N2','F3','F2','F1'};  
matrixplot(x,'FigSize','Full','XVarNames',dc_names,'YVarNames',dc_names,'ColorBar','on');
% matrixplot(x,'XVarNames',XVarNames,'YVarNames',XVarNames,'DisplayOpt','off','FigSize','Full','ColorBar','on');
% matrixplot(x,'XVarNames',XVarNames,'YVarNames',XVarNames,'DisplayOpt','off','FigSize','Full','ColorBar','on','FigShape','d');


h = HeatMap(x);

h.addTitle('ECOC PD Values');
h.addXLabel('DC');
h.addYLabel('DC');