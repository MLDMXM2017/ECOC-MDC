% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 画每个类的中的所有点
% % % % % % % % % % % % % % % % % % % % % % % % % % % % 
function draw_pic(c1,c2,train,label,cplx)
%     global path;
%     global picnum;
%     global datasetname;
%     global sfeature;
%     picnum=picnum+1;
%     picpath=[path,datasetname,'_',num2str(sfeature(1)),'-',num2str(sfeature(2)),'_',cplx,'_',num2str(picnum),'.tif'];
%     [data1,data2]=get_data1A2(c1,c2,train,label);
%    
%     data1=data1(:,sfeature);
%     data2=data2(:,sfeature);
%     linewidth=2;
%     fontname='Times New Roman';
%     fontsize=10;
%     set(gcf,'Position',[100 100 260 220]); %图片大小
%     set(gca,'Position',[.13 .17 .80 .74]);%设置xy坐标轴在图片中占得比例
%     
%     xlabel('f-1','FontName',fontname,'FontSize',fontsize,'Vertical','top'); %x轴
%     ylabel('f-2','FontName',fontname,'FontSize',fontsize,'LineWidth',linewidth,'Vertical','middle'); %y轴
%     title('data complexity','FontName',fontname,'FontSize',fontsize,'LineWidth',linewidth);%标题
% 
%     hold on
%         scatter(data1(:,1),data1(:,2),1,'k','*');
%         scatter(data2(:,1),data2(:,2),1,'r','d');  
%     hold off
%     saveas(gcf ,picpath,'tiff');
end