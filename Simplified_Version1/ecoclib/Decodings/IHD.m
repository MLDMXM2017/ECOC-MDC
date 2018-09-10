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

function class=IHD(x,ECOC)

delta=zeros([size(ECOC,1) size(ECOC,1)]);
for i=1:size(ECOC,1)
    for j=1:size(ECOC,1)
            delta(i,j)=sum(abs(ECOC(i,:)-ECOC(j,:)))/2;
    end
end
for i=1:size(ECOC,1)
    L(i)=sum(abs(x-ECOC(i,:)))/2;
end
q=inv(delta)*L';
[maximum,pos]=max(q);
class=pos;

%##########################################################################