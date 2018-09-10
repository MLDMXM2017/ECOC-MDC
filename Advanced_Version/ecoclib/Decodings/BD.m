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

function d=BD(x,y,X,Y,x_1,y_1,x_2,y_2,area)

x_s=x_1;
if x(1)==y(1)
    y_s=y_1;
else
    if y(1)==0
        y_s=Y;
    else
        y_s=y_2;
    end
end
for i=2:length(x)
    if x(i)==y(i)
        y_s=y_s.*y_1;
    else
        if x(i)==0
            y_s=y_s.*Y;
        else
            y_s=y_s.*y_2;
        end
    end
end
area_2=sum(y_s);
required_area=area_2*area;
[maximum,pos]=max(y_s);
count=maximum;
count_left=1;
out=1;
while (count<required_area & out)
    if (pos-count_left)>0
        count=count+y_s(pos-count_left);
        count_left=count_left+1;
    else
        out=0;
    end
end
count_left=count_left+1;
if count_left>pos
    count_left=pos-1;
end
d=1-x_s(pos-count_left);

%##########################################################################