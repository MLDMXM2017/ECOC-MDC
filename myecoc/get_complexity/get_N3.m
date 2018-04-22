%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成复杂度--N3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c1,c2,tcplx]=get_N3(c1,c2,train,label)
    cplx=get_complexityN3(c1,c2,train,label);
    tcplx=cplx;
    
    disp('生成编码矩阵：N3');
 
    while(true)
        % % % swap min max
        c1_s=c1;
        c2_s=c2;

        c1mx=get_maxdis(c1,train,label);
        c2mx=get_maxdis(c2,train,label);

        if(c1mx==0 & c2mx==0)
            break;
        end

        [c1_xx,c2_xx]=swap(c1,c2,c1mx,c2mx);
        xxcplx=get_complexityN3(c1_xx,c2_xx,train,label);

        if(xxcplx<cplx)
            c1=c1_xx;
            c2=c2_xx;
            cplx=xxcplx;     
            tcplx=[tcplx cplx];         
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end        
    end    
end

function clpx=get_complexityN3(c1,c2,train,label) 
   % % %设置train data & label
   [data1,data2]=get_data1A2(c1,c2,train,label);
   traindata=[data1;data2];
   trainlabel=zeros([size(data1,1)+size(data2,1),1]);
   trainlabel(1:size(data1,1))=1;
   trainlabel(size(data1,1)+1:size(data2,1))=2;  
  
%    % % %留一法训练 & 检验（MATALB自带）
%    count=0;
%    N=size(traindata,1);
%    for i=1:size(traindata,1)
%       [tnindex,ttindex] = crossvalind('LeaveMOut',N,1);
%       
%       % % 找到train对应的label
%       td=traindata(tnindex',:);
%       tl=trainlabel(tnindex');      
%       ttd=traindata(ttindex',:);
%       ttl=trainlabel(ttindex',:);
%       
%       knn_model =ClassificationKNN.fit(td,tl,'NumNeighbors',1);
%       predict_label = predict(knn_model,ttd);
%       if(predict_label~=ttl)
%            count=count+1;
%       end
%    end

  % % %留一法训练 & 检验（自己写的）
   count=0;
   N=size(traindata,1);
   for i=1:size(traindata,1)      
     
      %测试集
      ttd=traindata(i,:);
      ttl=trainlabel(i);    
      
      %训练集
      td=traindata;
      td(i,:)=[];
      tl=trainlabel;
      tl(i)=[];
      
      knn_model =ClassificationKNN.fit(td,tl,'NumNeighbors',1);
      predict_label = predict(knn_model,ttd);
      if(predict_label~=ttl)
           count=count+1;
      end
   end
   
   clpx=count/size(traindata,1);
  
end

function index=get_maxdis(c,train,label)
    % % %找到类的样本点
    index=0;
    mc=get_meanp(c,train,label);    
    
    % % %样本之间的距离
    dis=zeros([size(mc,1),size(mc,1)]);
    for i=1:size(mc,1)
        for j=i+1:size(mc,1)
            dis(i,j)=get_ppdis(mc(i,:),mc(j,:));
            dis(j,i)=dis(i,j);            
        end 
    end
    
    % % % 类内距离最远的点
    for i=1:size(mc,1)
        tdis(i)=sum(dis(i,:));
    end
    index=find(tdis==max(tdis));
    if(size(index,2)>1)
        index=index(1);
    end 
end    

function dis=get_ppdis(p1,p2)
    dis=0;
    for i=1:size(p1,2)
        dis=dis+(p1(1,i)-p2(1,i))^2;
    end
    dis=sqrt(dis);    
end

function mc=get_meanp(c,train,label)
    for i=1:size(c,1)
        for p=1:size(train,2)
           mp(p)=mean(train(find(label==c(i)),p)); 
        end
        mc(i,:)=mp;
    end
end

function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
end


