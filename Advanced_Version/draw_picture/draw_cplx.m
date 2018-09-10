%##########################################################################

% <ECOC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this file provides the way to draw the line chart of data complexity.
% x axis: the time of data complexity change.
% y axis: the data complexity value.

%##########################################################################

function draw_cplx()

Learners={'svm','nativebayes'};
fs_method = {'roc','ttest','wilcoxon'};
DS={'Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1','SRBCT'};
legend_names  = {'Cancers','DLBCL','GCM','Leukemia1','Leukemia2','Lung','SRBCT'};
ylabels = {'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
fontsize =8;

matfile_path = '../../data/data_fs_10--150_pair_newN3-F3';
pic_res_path = '../../data/pic/cplx/';
mkdir(pic_res_path)

clf;%Çå¿Õfigure
figure
set(gca, 'Position', [9 145 955 399]);

for fs_option = 1:3
    clf;
    for dnum = 4:5
        subplot(2,1,dnum-3);
        title(ylabels{dnum},'FontSize',fontsize);
        
        for fs_size = 150
            
            filepath = [matfile_path,'data_fs_',num2str(fs_size),'\',fs_method{fs_option},'\dcplx'];
            tdcplx = create_dtcplx(filepath,Learners{1},DS);
            draw(tdcplx,pic_res_path,fs_size,dnum,fs_method{fs_option});            
        end
    end
    legend(legend_names,'location','best','FontSize',fontsize);
    
    saveas(gca ,[pic_res_path,'\',ylabels{dnum},'_',fs_method{fs_option},'_',num2str(fs_size)],'fig');
    disp([pic_res_path,'\',ylabels{dnum},'_',fs_method{fs_option},'_',num2str(fs_size)]);
    saveas(gca ,[pic_res_path,'\',ylabels{dnum},'_',fs_method{fs_option},'_',num2str(fs_size)],'tiff');
    
end
end


function draw(cplx,data_complexity)
DS={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1'};
linestyle={'p-','*-','d-','s-','+-','o-','x-','<-','^-'};
colors =[0,0,0; 0.8,0,0; 0,0,1; 0.3,0,0.5; 0,0.6,1; 0.6,0,0;0.84,0.6,0.6; 0.5,0.2,0.9;];
ylabels = {'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
fontsize = 12;

for dnum=data_complexity%data complexity
    cp={};
    
    hold on
    for i=1:size(cplx,1)%data set
        cp=cplx{i,2}{dnum};%obtain correspongding cplx
        temp={};
        for k=1:size(cp,2)
            if(size(cp{k},2)>=2)%if occur local interation
                temp{size(temp,2)+1}=cp{k};%save loacal interation
            end
        end
        if(isempty(temp))
            Y=cp{size(cp,2)};
            %save the most local interation
        else
            gaps=zeros([1,10]);
            for k=1:size(temp,2)
                tt=temp{k};
                gap=zeros([1,10]);
                for l=1:size(tt,2)-1
                    gap(l)=abs(tt(l+1)-tt(l));
                end
                gaps(k)=max(gap);
            end
            Y=temp{find(gaps==max(gaps),1,'first')};
        end
        X=sort(randperm(size(Y,2)));
        plot(X,Y,linestyle{i},'Color',colors(i,:),'markersize',6);
        
    end
    
    hold off
    legend(DS,'location','best');
    xlabel('times','Fontsize',fontsize); %x axis
    ylabel([ylabels{dnum},'-value'],'Fontsize',fontsize); %y axis
    set(gca,'XTick',0:1:5);
    grid on;
    
end%end of dnum
end%end of function

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