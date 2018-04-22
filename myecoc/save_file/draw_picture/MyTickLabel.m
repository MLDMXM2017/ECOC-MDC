% --------------------------------------------------- %  调整坐标轴刻度标签子函数  % ---------------------------------------------------
function MyTickLabel(ha,tag)
%   根据显示范围自动调整坐标轴刻度标签的函数
%   ha   坐标系句柄值
%   tag  调整坐标轴刻度标签的标识字符串，可用取值如下：
%        'Auto' --- 将x轴刻度标签旋转90度，y轴刻度标签不作调整
%        'Tril' --- 将x轴刻度标签旋转90度，并依次缩进，y轴刻度标签不作调整
%        'Triu' --- 将x轴刻度标签旋转90度，y轴刻度标签依次缩进
%   Example:
%   MyTickLabel(gca,'Tril');
%  %   CopyRight：xiezhh（谢中华）,2013.1编写
if ~ishandle(ha)
    warning('MATLAB:warning2','第一个输入参数应为坐标系句柄');
    return;
end
if ~strcmpi(get(ha,'type'),'axes')
    warning('MATLAB:warning3','第一个输入参数应为坐标系句柄');
    return;
end
axes(ha);
xstr = get(ha,'XTickLabel');
xtick = get(ha,'XTick');
xl = xlim(ha);
ystr = get(ha,'YTickLabel');
ytick = get(ha,'YTick');
yl = ylim(ha);
set(ha,'XTickLabel',[],'YTickLabel',[]);
x = zeros(size(ytick)) + xl(1) - range(xl)/30;
y = zeros(size(xtick)) + yl(1) - range(yl)/70;
nx = numel(xtick);
ny = numel(ytick);
if strncmpi(tag,'Tril',4)
    y = y + (1:nx) - 1;
elseif strncmpi(tag,'Triu',4)
    x = x + (1:ny) - 1;
end
text(xtick,y,xstr,...
    'rotation',90,...
    'Interpreter','none',...
    'color','r',...
    'HorizontalAlignment','left');
text(x,ytick,ystr,...
    'Interpreter','none',...
    'color','r',...
    'HorizontalAlignment','right');
end