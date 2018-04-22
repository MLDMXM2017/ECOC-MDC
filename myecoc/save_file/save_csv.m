%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 保存正确度测度和复杂度变换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_csv(cplx,ica,genpath,name)
    csvpath = [genpath,'/acc+cplx'];
    mkdir(csvpath);
    save_acc(cplx,ica,csvpath,name);
    save_cplx(cplx,csvpath,name);
end

function save_acc(cplx,ica,path,name)
    acc=[];
    for i=1:size(cplx,1) %数据集个数
        for j=1:size(cplx{i,2},2)%第几个复杂度      
            acc=[acc;cplx{i,2}{j}];
        end 
        for j=1:size(ica{i,2},2)
            temp=ica{i,2}{j};
            acc=[acc;temp(1:5)];
        end     
        temp=zeros([1,5]);
        temp(1,:)=-11111;
        acc=[acc;temp];
    end
    csvwrite([path,'/accuracy_',name,'.csv'],acc);  
end

%所有数据集的复杂度
function save_cplx(cplx,path,name)
    xx=[];
    for i=1:size(cplx,1) %数据集的个数        
       cp=get_fcplx(cplx{i,6});%获得每个数据集的cplx集合       
       if(size(xx,2)<size(cp,2) && isempty(xx)==false)%原先的复杂度列数小
           temp=zeros([size(xx,1),size(cp,2)-size(xx,2)]);
           temp(1:size(xx,1),:)=-11111;
           xx=[xx temp];%加长列
       elseif(size(xx,2)>size(cp,2))
           temp=zeros([size(cp,1),size(xx,2)-size(cp,2)]);
           temp(1:size(cp,1),:)=-11111;
           cp=[cp temp];%加长列             
       end       
       temp=zeros([1,size(cp,2)]);
       temp(:)=-10000;%拼接空字符串
       xx=[xx;cp;temp];
    end
    csvwrite([path,'/complexity_',name,'.csv'],xx);  
end

function cp=get_fcplx(tcplx)
    fillnum=-11111;
    maxnum=5;
    cp=[];
    for i=1:size(tcplx,2) %1-8个数据复杂度       
       column=tcplx{i};%每一个数据复杂度
       fcplx=[];
       for j=1:size(column,2)%每个复杂度的深度cplx
            new_row=column{j};
            if(size(new_row,2)~=maxnum)%如果列长不够，加长列
                temp=zeros([1,maxnum-size(new_row,2)]);
                temp(1,:)=fillnum;
                new_row=[new_row temp];
            end            
            fcplx=[fcplx;new_row];%拼接每一行
       end
       new_row=zeros([1,maxnum]);
       new_row(1,:)=i*-11111;
       cp=[cp;fcplx;new_row];%为每个复杂度添加i分割
    end
end
