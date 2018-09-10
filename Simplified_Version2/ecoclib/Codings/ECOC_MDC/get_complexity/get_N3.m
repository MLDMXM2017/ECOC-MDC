%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is part of ECOC-MDC
% this file is to generate two groups based on N3 DC measure
% The related intorduction are shown in the paper
% <Analysis of data complexity measures for classification>

%##########################################################################
function [c1,c2,tcplx]=get_N3(c1,c2,train,label)
    disp('split class based on the N3 measure');
    cplx=get_complexityN3(c1,c2,train,label);
    tcplx=cplx; 
    while(true)
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
   % set train data & label
   [data1,data2]=get_data1A2(c1,c2,train,label);
   traindata=[data1;data2];
   trainlabel=zeros([size(data1,1)+size(data2,1),1]);
   trainlabel(1:size(data1,1))=1;
   trainlabel(size(data1,1)+1:size(data2,1))=2;  
 
   % leave one out
   count=0;
   N=size(traindata,1);
   for i=1:size(traindata,1)      
     
      % train
      ttd=traindata(i,:);
      ttl=trainlabel(i);    
      
      % test
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
    index=0;
    mc=get_meanp(c,train,label);    
    
    dis=zeros([size(mc,1),size(mc,1)]);
    for i=1:size(mc,1)
        for j=i+1:size(mc,1)
            dis(i,j)=get_ppdis(mc(i,:),mc(j,:));
            dis(j,i)=dis(i,j);            
        end 
    end
    
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