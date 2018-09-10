%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the 3D hist chart of accuracy,data
% comopleity and frequency of occurrence.

%##########################################################################

function draw_error_cplx_fsize_3D()
DS ={'Leukemia3'};
Learners={'naivebayes','svm'};  
FS = {'wilcoxon'};
DC = {'F1','F2','F3','N2','N3','C1'};
feature_size = 100:5:150;
pic_res_path = '../../data/pic/error_cplx_fssize_3D/ACLS+Le2/';

for fs_option = 1: size(FS,2) %feature selection
    
    for lindex = 1: size(Learners,2) %base learner%
     
        for dc_option = 1:6        
       
            data_cplxs = [];
            data_errors = [];            
            for feature_option = 1:size(feature_size,2) %feature size
                
                features = feature_size(feature_option);                
                for dataset_option = 1: size(DS,2) %dataset                    
                    %加载dcplx数据
                    matname=['../../data/data_fs_10--150_pair_newN3-F3/data_fs_',num2str(features),'/',FS{fs_option},'/dcplx/dcplx_',Learners{lindex},'_',DS{dataset_option},'.mat'];
                    load(matname);
                    
                    data_cplxs = [data_cplxs dcplx{size(dcplx,1),13}{1,dc_option}];
                    data_errors = [data_errors dcplx{size(dcplx,1),11}{1,dc_option}*100];
                end
                
            end
            % drop value = inf points
            inx = find(data_cplxs == inf);
            data_cplxs(inx) = [];
            data_errors(inx) = [];
            frequence = cal_frequence(data_cplxs,data_errors);
            draw_3D_hist(data_cplxs',data_errors',frequence);
            
            filepath = [pic_res_path,FS{fs_option}];
            mkdir(filepath);   
            
            filename = [FS{fs_option},'_',Learners{lindex},'_',DC{dc_option}];
            disp([filepath,'\',filename]);
            
            saveas(gca ,[filepath,'\',filename,'_',DS{dataset_option},'_100-150'],'fig');
            saveas(gca ,[filepath,'\',filename,'_',DS{dataset_option},'_100-150'],'tiff');
        end
    end
end
end

% x:complexity_level
% y:classifiers_error
function z = cal_frequence(x,y)
table = [x' y'];
[c] = unique(table,'rows');
z = zeros(size(c,1),1);
for i = 1:size(table,1)
    for j = 1:size(c,1)
        if table(i,:) == c(j,:)
            z(j,1) = z(j,1) + 1;
            break;
        end
    end
end
end

function draw_3D_hist(x,y,z)
fontsize = 10;
figure,hold on
set (gcf,'Position',[400,100,350,300]);
dat = [y,x];
hist3(dat);

n = hist3(dat); % default is to 10x10 bins
n1 = n';
n1(size(n,1) + 1, size(n,2) + 1) = 0;

% X axis and Y axis
xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1)+1);%x值
yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,1)+1);%y值

% Z axis
h = pcolor(xb,yb,n1);
h.ZData = ones(size(n1)) * -max(max(n));

% color bar
colormap(hot) % heat map
colorb = colorbar('location','eastoutside','FontSize',fontsize,'Position',[0.83 0.2 0.05 0.5]);
colorb.Label.String = 'Z-Frequence';
colorb.Label.FontSize = fontsize;
xlabel('X-Error','FontSize',fontsize); %x axis
ylabel('Y-Complexity','FontSize',fontsize); %y axis
zlabel('Z-Frequence','FontSize',fontsize); %z axis
grid on
view(3);

hold off;

end