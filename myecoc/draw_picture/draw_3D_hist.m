function h = draw_bar_3D(x,y,z)
figure,
hold on
dat = [y,x];
hist3(dat);

%拓展2D
n = hist3(dat); % default is to 10x10 bins
n1 = n';
n1(size(n,1) + 1, size(n,2) + 1) = 0;

%画2D投影
xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1)+1);%x值
yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,1)+1);%y值

%上色
h = pcolor(xb,yb,n1);

%画z轴
h.ZData = ones(size(n1)) * -max(max(n));
colormap(hot) % heat map
colorbar('location','East');
xlabel('x-error'); %x轴
ylabel('y-complexity'); %y轴
zlabel('z-frequence');
grid on
view(3);

hold off;


