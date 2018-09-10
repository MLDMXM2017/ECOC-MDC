%##########################################################################

% <ECOCs Library. Coding and decoding designs for multi-class problems.>
% Copyright (C) 2009 Sergio Escalera sergio@maia.ub.es

%##########################################################################

% This file is part of the ECOC Library.

% ECOC Library is free software; you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free Software 
% Foundation; either version 2 of the License, or (at your option) any later version. 

% This program is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR 
% A PARTICULAR PURPOSE. See the GNU General Public License for more details. 

% You should have received a copy of the GNU General Public License along with
% this program. If not, see <http://www.gnu.org/licences/>.

%##########################################################################

function [result,confusion,labels,Values,X]=Decoding(TestData,classes,ECOC,base,Classifiers,decoding,base_test,base_test_params,custom_decoding,custom_decoding_param)

alpha=0;
feature=0;
x=zeros([1 size(ECOC,2)]);

switch decoding
    case 'BDEN', % setting the parameters for BDEN decoding strategy
        inc=0.005;
        sigma=2000;
        range_i=0;
        range_d=1;
        area=1/3;
        [XY,Y]=ramp_gaussian(sigma,range_i,inc,range_d);
        y=ones([1 length(Y)]);
        x_1=range_i:inc:range_d;
        counter=1;
        for j=0:inc:(range_d-range_i)
            y_1(counter)=j/2;
            counter=counter+1;
        end
        x_2=range_i:inc:range_d;
        counter=1;
        for j=(range_d-range_i):-1*inc:0
            y_2(counter)=j/2;
            counter=counter+1;
        end
    case 'PD', % setting the parameters for probabilistic decoding strategy
        dictionary=[];
        for i=1:length(classes)
            dictionary(i)=2^(sum(ECOC(i,:)==0));
        end
        c=(2^size(ECOC,2))-sum(dictionary);
        cq=(2^size(ECOC,2));
        alfa=c/(cq*length(classes));
        A=[];
        B=[];
        for i=1:size(ECOC,2)
            out=[];
            target=[];
            prior1=0;
            prior0=0;
            aux=0;
            for j=1:length(classes)
                if ECOC(j,i)~=0
                    pos=find(TestData(:,size(TestData,2))==classes(j));
                    samples=TestData(pos,1:size(TestData,2)-1);
                    for k=1:size(samples,1)
                        try,
                            out(i)=feval(base_test,samples(k,:),Classifiers{i}.classifier,base_test_params);
                        catch,
                            error('Exit: Decoding error when using custom testing strategy.');
                        end
                        if ECOC(j,i)==1
                            target(end+1)=1;
                            prior1=prior1+1;
                        else
                            target(end+1)=0;
                            prior0=prior0+1;
                        end
                    end
                end
            end
            [A(i),B(i)]=AB(out,target,prior1,prior0);
        end
    case {'LLW','ELW'}, % setting the parameters for Linear and Exponential loss-weighted decoding strategies
        for z=1:size(ECOC,2)
            w1=[];
            w2=[];
            for i=1:size(Classifiers{z}.FirstSet,1)
                try,
                    w1(i)=feval(base_test,Classifiers{z}.FirstSet(i,:),Classifiers{z}.classifier,base_test_params);
                catch,
                    error('Exit: Decoding error when using custom testing strategy.');
                end
            end
            for i=1:size(Classifiers{z}.SecondSet,1)
                try,
                    w2(i)=feval(base_test,Classifiers{z}.SecondSet(i,:),Classifiers{z}.classifier,base_test_params);
                catch,
                    error('Exit: Decoding error when using custom testing strategy.');
                end
            end
            weights(z)=(sum(w1==1)+sum(w2==-1))/(length(w1)+length(w2));
        end
end

confusion=zeros([length(classes) length(classes)]);
hits=0;
labels=zeros([1 size(TestData,1)]);

for z=1:size(ECOC,2)
     try,
        X(:,z)=feval(base_test,TestData(:,1:size(TestData,2)-1),Classifiers{z}.classifier,base_test_params);
     catch,
        error('Exit: Decoding error when using custom testing strategy.');
     end
end

for i=1:size(TestData,1) % for each sample in the test set
    x=X(i,:);
    minimum=Inf;
    if strcmp(decoding,'IHD')
        class=IHD(x,ECOC);
    elseif strcmp(decoding,'PD')
        class=PD(x,ECOC,A,B,alfa);
    else
        for k=1:size(ECOC,1)
            switch decoding,
                case 'HD', % Hamming decoding
                    d=HD(x,ECOC(k,:));
                case 'ED', % Euclidean decoding
                    d=ED(x,ECOC(k,:));
                case 'NED',% Euclidean decoding without zero
                    d=NED(x,ECOC(k,:));
                case 'LAP', % Laplacian decoding
                    d=LD(x,ECOC(k,:));
                case 'BDEN', % Beta-density decoding
                    d=BD(x,ECOC(k,:),XY,Y,x_1,y_1,x_2,y_2,area);
                case 'AED', % Attenuated Euclidean decoding
                    d=AED(x,ECOC(k,:));
                case 'LLB', % Linear Loss-based decoding
                    d=LLB(x,ECOC(k,:));
                case 'ELB', % Exponential Loss-based decoding
                    d=ELB(x,ECOC(k,:));
                case 'LLW', % Linear Loss-Weighted decoding
                    d=LLW(x,ECOC(k,:),abs(ECOC(k,:).*weights)./sum(abs(ECOC(k,:).*weights)));
                case 'ELW', % Exponential Loss-Weighted decoding
                    d=ELW(x,ECOC(k,:),abs(ECOC(k,:).*weights)./sum(abs(ECOC(k,:).*weights)));
                case 'CUSTOM',
                    try,
                        d=feval(custom_decoding,x,ECOC(k,:),custom_decoding_params);
                    catch,
                        error('Exit: Decoding error when using custom decoding strategy.');
                    end
                otherwise,
                    error('Exit: Decoding type bad defined.');
            end
            if d<=minimum
                minimum=d;
                class=k;
            end
            Values(i,k)=d;
        end
    end
    labels(i)=classes(class);
    if classes(class)==TestData(i,size(TestData,2))
        hits=hits+1;
    end
    if length(unique(TestData(:,size(TestData,2))))~=1
        confusion(find(classes==TestData(i,size(TestData,2))),class)=confusion(find(classes==TestData(i,size(TestData,2))),class)+1;
    end
end

result=hits/size(TestData,1);

end

%##########################################################################

function [x,y]=ramp_gaussian(sigma,range_left,inc,range_right)

x=range_left:inc:range_right;
for i=1:length(x)
   y(i)=exp((-0.5*(x(i)^2))/(sigma^2)); 
end
end