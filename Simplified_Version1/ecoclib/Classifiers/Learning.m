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

function Classifiers=Learning(data,Parameters,classes,positions)

ECOC=Parameters.ECOC
base=Parameters.base;

Classifiers=[];
for i=positions % for each column of the coding matrix
    FirstSet=[];
    SecondSet=[];
    for j=1:size(ECOC,1) % for each row of the coding matrix
        if ECOC(j,i)==1 % save the current class data in the first partition
            pos=find(data(:,size(data,2))==classes(j));
            FirstSet(size(FirstSet,1)+1:size(FirstSet,1)+length(pos),:)=data(pos,1:size(data,2)-1);
        elseif ECOC(j,i)==-1 % save the current class data in the second partition
            pos=find(data(:,size(data,2))==classes(j));
            SecondSet(size(SecondSet,1)+1:size(SecondSet,1)+length(pos),:)=data(pos,1:size(data,2)-1);
        end
    end
    try, % apply the base classifier over the current partition of classes
        Custom_classifier=feval(Parameters.base,FirstSet,SecondSet,Parameters.base_params);
    catch,
        error('Exit: Base classifier bad defined for custom base classifier.');
    end
    Classifiers{length(Classifiers)+1}.classifier=Custom_classifier; % save current classifier and data
    Classifiers{length(Classifiers)}.FirstSet=FirstSet;
    Classifiers{length(Classifiers)}.SecondSet=SecondSet;
end