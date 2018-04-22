function plot_3D(record)
figure;
% load seamount
% dat = [-y,x]; % Make grid, correcting for negative y-values
hold on
% hist3(record,[20 20],'FaceAlpha',.65); % Draw histogram in 2D
hist3(record,[20 20]); % Draw histogram in 2D
n2 = hist3(record,[20 20]); % Extract histogram data; default to 10x10 bins
% hist3(record,[15 15]); % Draw histogram in 2D
% n2 = hist3(record,[15 15 ]); % Extract histogram data; default to 10x10 bins
n1 = n2';
n1( size(n2,1) + 1 ,size(n2,2) + 1 ) = 0;

% Generate grid for 2-D projected view of intensities
xb = linspace( min(record(:,1)) , max(record(:,1)) , size(n2,1) + 1);
yb = linspace( min(record(:,2)) , max(record(:,2)) , size(n2,1) + 1);

% Make a pseudocolor plot on this grid
h = pcolor(xb,yb,n1);

% Set the z-level and colormap of the displayed grid
set(h, 'zdata', ones(size(n1)) * -max(max(n2)))
colormap(hot) % heat map
% title...
% ('Seamount: Data Point Density Histogram and Intensity Map');
grid on
view(3); % Display the default 3-D perspective