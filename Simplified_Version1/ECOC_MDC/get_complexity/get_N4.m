%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is part of ECOC-MDC
% this file is to generate two groups based on N4 DC measure
% The related intorduction are shown in the paper
% <Analysis of data complexity measures for classification>

%##########################################################################
function [c1,c2,tcplx]=get_N4(c1,c2,train,label)
    disp('split class based on the N4 measure');
    tcplx=[];
    [cplx,flag,ttlabel,predict_label]=get_complexityN4(c1,c2,train,label);
    tcplx=cplx;
 
    while(true)
        c1_s=c1;
        c2_s=c2;

        [index1,index2]=get_index(ttlabel,predict_label,flag,c1,c2);
        % no class should be switched
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
    
    [flag1,test1,label1]=get_test(c1,data1,label1,1);
    [flag2,test2,label2]=get_test(c2,data2,label2,2);
    flag=[flag1 flag2];
    testdata=[test1;test2];
    ttlabel=[label1;label2];  

    label=zeros([size(c1,1)+size(c2,1),1]);
    label(1:size(data1,1),:)=1;
    label(size(data1,1)+1:size(data1,1)+size(data2,1),:)=2;
    
    knn_model =ClassificationKNN.fit([data1;data2],label,'NumNeighbors',1);
    predict_label = predict(knn_model,testdata);
    
    clpx=1-calaccracy(predict_label,ttlabel');
   
end

function [index1,index2]=get_index(ttlabel,preict_label,flag,c1,c2)
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
       tranddata=[tranddata;randdata];  
       trandlabel=[trandlabel;randlabel];
    end
        
    n=size(tranddata,1);    
    
    testdata=zeros([(n*(n-1))/2,size(tranddata,2)]);
    count=1;  
    flag={};
  
    for i=1:size(tranddata,1)
        for j=i+1:size(tranddata,1)             
        	n=rand(1,1);     
            temp = [tranddata(i,:);tranddata(j,:)];
            testdata(count,:)=interp1(temp,size(temp,1)*0.55,'linear');
            
            flag{count}=[trandlabel(i),trandlabel(j)];
            count=count+1;
        end
    end 
    
    label=zeros([size(testdata,1),1]);
    label(:,1)=option;    
end

function [c1,c2]=swap(c1,c2,i,j)
    temp=c1(i);
    c1(i)=c2(j);
    c2(j)=temp;
end

function [ratio]=calaccracy(ls,lt)
    size1=size(ls,1);
    size2=size(lt,2);
    if(size1~=size2)
        error('Exit: the size of label is not equal.');
    end
    count=0;
    for i=1:size1
        if(ls(i,1)==lt(1,i))
            count=count+1;
        end
    end
    if(size1==0)
       error('Exit: the size of label is 0.');
    end
    ratio=count/size1;    
end
