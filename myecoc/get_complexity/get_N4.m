%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 生成复杂度--N4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c1,c2,tcplx]=get_N4(c1,c2,train,label)
    tcplx=[];
    [cplx,flag,ttlabel,predict_label]=get_complexityN4(c1,c2,train,label);
    tcplx=cplx;
 
    disp('生成编码矩阵：N4');
    while(true)
        % % %   swap min max
        c1_s=c1;
        c2_s=c2;

        [index1,index2]=get_index(ttlabel,predict_label,flag,c1,c2);
        %没有可以交换的类别
        if(index1==0 && index2==0)
            break;
        end

        [c1_xx,c2_xx]=swap(c1,c2,index1,index2);
        [xxcplx,flag,ttlabel,predict_label]=get_complexityN4(c1_xx,c2_xx,train,label);

        if(xxcplx<cplx)
            c1=c1_xx;
            c2=c2_xx;
            cplx=xxcplx;     
            tcplx=[tcplx cplx];
            draw_pic(c1,c2,train,label,dsign);
        else
            c1=c1_s;
            c2=c2_s;
            break;
        end        
    end    
end

function [clpx,flag,ttlabel,predict_label]=get_complexityN4(c1,c2,train,label)
    [data1,data2]=get_data1A2(c1,c2,train,label);
    [label1,label2]=get_label1A2(c1,c2,train,label);
    
    % % %设置test data & label & flag
    [flag1,test1,label1]=get_test(c1,data1,label1,1);
    [flag2,test2,label2]=get_test(c2,data2,label2,2);
%     if(isempty(label1)==false && isempty(label2)==false && isempty(test1)==false && isempty(test2)==false && size(flag1,1)~=0 && size(flag2,1)~=0)
        flag=[flag1 flag2];
        testdata=[test1;test2];
        ttlabel=[label1;label2];  
%     end
    
    % % %设置train label
    label=zeros([size(c1,1)+size(c2,1),1]);
    label(1:size(data1,1),:)=1;
    label(size(data1,1)+1:size(data1,1)+size(data2,1),:)=2;
    
    % % %训练&预测
    knn_model =ClassificationKNN.fit([data1;data2],label,'NumNeighbors',1);
    predict_label = predict(knn_model,testdata);
    
    clpx=1-calaccracy(predict_label,ttlabel');
   
end

function [index1,index2]=get_index(ttlabel,preict_label,flag,c1,c2)
    % % %测试结果和预测结果比较，找到错误结果中频率最高的类别
    count=zeros([1,max(c1)+max(c2)]);
    for i=1:size(ttlabel,1)
        if(ttlabel(i)~=preict_label(i))
            count(flag{i}(1))=count(flag{i}(1))+1;
            count(flag{i}(2))=count(flag{i}(2))+1;
        end
    end
    if(max(count)==0)
        index1=0;
        index2=0;        
        return;
    end        
    index1=find(count(c1')==max(count(c1')));
    index2=find(count(c2')==max(count(c2')));     
    
    if(size(index1,2)>1) index1=index1(1); end
    if(size(index2,2)>1) index2=index1(1); end   
end

% function [flag,testdata,ttlabel]=get_test(c,train,label,option)
%     % % %计算每个类的样本点
%     for i=1:size(c,1)
%         for p=1:size(train,2)
%             m(p)=mean(train(find(label==c(i)),p));
%         end
%         mc(i,:)=m;
%     end
%     
%     %c只包含一个类
%     if(size(c,1)==1)
%         testdata=[];
%         flag={};
%         ttlabel=[];
%         return;
%     end
%     
%     % % %对样本点进行线性差值
%     n=size(c,1);
%     testdata=zeros([(n*(n-1))/2,size(mc,2)]);
%     count=1;  
%     flag={};
%     for i=1:size(c,1)
%         for j=i+1:size(c,1)
%             testdata(count,:)=interp1(mc(i,:),mc(j,:),(mc(i,:)+mc(j,:))/2,'linear');            
%             flag{count}=[c(i),c(j)];
%             count=count+1;
%         end
%     end 
%     
%     % % %获取label
%     ttlabel=zeros([size(testdata,1),1]);
%     ttlabel(:,1)=option;
%   
% end

function [flag,testdata,label]=get_test(c,cdata,clabel,option)
    minvalue = 0.000001;
    tranddata=[];
    trandlabel=[];
    for i=1:size(c,1)
       cd=cdata(find(clabel==c(i)),:);
       cl=clabel(find(clabel==c(i)),:);
       n=floor((size(cd,1)/2));
       if(n==1)
           n=2;
       end
       index=randperm(size(cd,1));
       randdata=cd(index(1:n),:);
       randlabel=cl(index(1:n),:);
       tranddata=[tranddata;randdata];%从group中随机选择若干点      
       trandlabel=[trandlabel;randlabel];
    end
        
    n=size(tranddata,1);    
    
    testdata=zeros([(n*(n-1))/2,size(tranddata,2)]);
    count=1;  
    flag={};
  
    for i=1:size(tranddata,1)
        for j=i+1:size(tranddata,1)             
        	n=rand(1,1);     
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             原先差值的方法
%             testdata(count,:)=interp1(tranddata(i,:),tranddata(j,:),(tranddata(i,:)*n),'linear');  
            
%             以sample为点进行差值
            temp = [tranddata(i,:);tranddata(j,:)];
            testdata(count,:)=interp1(temp,size(temp,1)*0.55,'linear');
            
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            flag{count}=[trandlabel(i),trandlabel(j)];
            count=count+1;
        end
    end 
    
    % % %获取label
    label=zeros([size(testdata,1),1]);
    label(:,1)=option;
    
end

function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
end

