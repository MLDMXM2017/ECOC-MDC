%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成单个codematrix和复杂度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cds,fcplx]=coding(class,traindata,trainlabel,cds,fcplx,total_cls_num,option) 
    global gcount;
    % % %计算复杂度，划分成两类
    s=floor(size(class)/2);
    t=size(class);
    c1=class(1:s,:);
    c2=class(s+1:t,:);
    if(size(c1,1)==0 | size(c2,1)==0)
        error('Exit:group c contains no subclass!');    
    else
        %%%m-1对复杂度匹配挑选复杂度最大的两类交换
        [c11,c12,tcplx] = get_complexity(c1,c2,traindata,trainlabel,option);
        
        %%%根据每种复杂度定做的local improvement
%         [c11,c12,tcplx]=select_clpx(option,c1,c2,traindata,trainlabel); 
    end   
    
    % % %生成code matrix
    code=zeros([total_cls_num,1]);
    code(c11)=1;
    code(c12)=-1;
    gcount=gcount+1;
    cds(:,gcount)=code;
    fcplx{gcount}=tcplx;
    
    %画出每一次group的复杂度值
%     draw_group_cplx(c11,c12,traindata,trainlabel,gcount)       
    
    if(size(c11,1)>=2)       
        [cds,fcplx]=coding(c11,traindata,trainlabel,cds,fcplx,total_cls_num,option);   
    end

    if(size(c12,1)>=2)        
        [cds,fcplx]=coding(c12,traindata,trainlabel,cds,fcplx,total_cls_num,option); 
    end
end

function [c11,c12,tcplx]=select_clpx(option,c1,c2,train,label)
    tcplx=[];
    switch(option)
        case 'F1'
         [c11,c12,tcplx]=get_F1(c1,c2,train,label);
        case 'F2'
         [c11,c12,tcplx]=get_F2(c1,c2,train,label);
        case 'F3'
         [c11,c12,tcplx]=get_F3(c1,c2,train,label);
        case 'N2'
         [c11,c12,tcplx]=get_N2(c1,c2,train,label);
        case 'N3'
         [c11,c12,tcplx]=get_N3(c1,c2,train,label);
        case 'N4'
         [c11,c12,tcplx]=get_N4(c1,c2,train,label);
        case 'L3'
         [c11,c12,tcplx]=get_L3(c1,c2,train,label);
        case 'Cluster'
         [c11,c12,tcplx]=get_Cluster(c1,c2,train,label);
        case 'AD-F1'
         [c11,c12,tcplx]=get_advanced_F1(c1,c2,train,label);   
        case 'W-F1'
         [c11,c12,tcplx]=get_weight_F1(c1,c2,train,label);    
        otherwise
            error('Exit:error option!');
    end    
end


function draw_group_cplx(c11,c12,traindata,trainlabel,gcount)

   
    DC_names = {'F1','F2','F3','N2','N3','N4','L3','Cluster'};        
    group_cplx(1) = get_complexityF1(c11,c12,traindata,trainlabel);  
    group_cplx(2) = get_complexityF2(c11,c12,traindata,trainlabel);  
    group_cplx(3) = get_complexityF3(c11,c12,traindata,trainlabel);  
    group_cplx(4) = get_complexityN2(c11,c12,traindata,trainlabel);  
    group_cplx(5) = get_complexityN3(c11,c12,traindata,trainlabel);  
    group_cplx(6) = get_complexityN4(c11,c12,traindata,trainlabel);  
    group_cplx(7) = get_complexityL3(c11,c12,traindata,trainlabel);  
    group_cplx(8) = get_complexityCluster(c11,c12,traindata,trainlabel);  

    picrespath = ['E:\桌面\ecoc\ecoc-2.26\ICDC-ECOC\data\pic\期刊\new_N3\group_cplx'];
    mkdir(picrespath);

    DC_names = {'F1','F2','F3','N2','N3','N4','L3','Cluster'};     
    fontsize = 8;
    draw_scatter(group_cplx,DC_names,picrespath,fontsize,gcount);
    draw_bar(group_cplx,DC_names,picrespath,fontsize,gcount);
    
end

function draw_scatter(group_cplx,DC_names,picrespath,fontsize,gcount)
    clf;
    linestyle={'p','*','d','s','+','o','x','<'};
    x=1:8;
    for i=1:8
        plot(x(i),group_cplx(i),linestyle{i},'markersize',fontsize);hold on;
    end 
    plot(group_cplx,'Color','black');   
    xlabel('DC','Fontsize',fontsize); %x轴
    ylabel('DC Values','Fontsize',fontsize); %y轴   
    grid on;        
    title(['第',num2str(gcount),'次']);
    legend(DC_names,'location','best');

    mkdir([picrespath,'\scatter']);
    
    saveas(gca ,[picrespath,'\scatter\',num2str(gcount)],'fig');  
    saveas(gca ,[picrespath,'\scatter\',num2str(gcount)],'tiff');    

end

function draw_bar(group_cplx,DC_names,picrespath,fontsize,gcount)
    clf;
    x = [1:8]'; 
    bar(x,group_cplx');
    text(x,group_cplx',num2str(group_cplx','%0.3f'),...
                            'HorizontalAlignment','center',...
                            'VerticalAlignment','bottom');

    set(gca,'XTickLabel',DC_names);
    set(gca,'XTickLabelRotation',90);  
    
    xlabel('DC','Fontsize',fontsize); %x轴
    ylabel('DC Values','Fontsize',fontsize); %y   
    title(['第',num2str(gcount),'次']);

    mkdir([picrespath,'\bar']);
    
    saveas(gca ,[picrespath,'\bar\',num2str(gcount)],'fig');  
    saveas(gca ,[picrespath,'\bar\',num2str(gcount)],'tiff');   

end
  
     
        
        