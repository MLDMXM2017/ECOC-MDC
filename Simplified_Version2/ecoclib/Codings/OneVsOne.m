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

function ECOC=OneVsOne(number_classes,hola)

ECOC=zeros([number_classes number_classes*(number_classes-1)/2]);
counter=1;
for i=1:number_classes-1
    for j=i+1:number_classes
        ECOC(i,counter)=1;
        ECOC(j,counter)=-1;
        counter=counter+1;
    end
end