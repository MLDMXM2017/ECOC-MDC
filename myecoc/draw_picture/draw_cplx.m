%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 绘制复杂度变换的折线图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function draw_cplx(cplx,respath,fs_size,data_complexity,fs_option)
    linestyle={'p-','*-','d-','s-','+-','o-','x-','<-','^-'};
    colors =[0,0,0; 0.8,0,0; 0,0,1; 0.3,0,0.5; 0,0.6,1; 0.6,0,0;0.84,0.6,0.6; 0.5,0.2,0.9;];
    ylabels = {'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
    fontsize = 12;

    for dnum=data_complexity%复杂度
        cp={};
 
        hold on
        for i=1:size(cplx,1)%数据集的个数
           cp=cplx{i,2}{dnum};%数据集对应的某个数据复杂度
           temp={};
           for k=1:size(cp,2)
                if(size(cp{k},2)>=2)%如果有局部迭代
                   temp{size(temp,2)+1}=cp{k};%保留有局部多次迭代的过程
                end
           end
           if(isempty(temp))
               Y=cp{size(cp,2)};
            %选取差距最大的迭代过程--多个迭代过程
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
%        datanames={'Breast','Cancers','DLBCL','GCM','Leukemia2','Leukemia3','Lung1',}; 
%        legend(datanames,'location','best');
       xlabel('times','Fontsize',fontsize); %x轴
       ylabel([ylabels{dnum},'-value'],'Fontsize',fontsize); %y轴   
       set(gca,'XTick',0:1:5);
       grid on;
       
    end%end of dnum
    
end%end of function 