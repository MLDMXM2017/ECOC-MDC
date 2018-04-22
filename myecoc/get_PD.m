function PD = get_PD(M1,M2)
     index = find(M1==-1);
     M1(index) = 2;
     index = find(M2==-1);
     M2(index) = 2;
     
     len1 = size(M1,2);
     len2 = size(M2,2);
     PD = 0;
     for i = 1:len1%M1 i row
         minvalue = 111111;
         for j = 1:len2%M2 j row
             nowvalue = 0;
             if(size(M1,1) < size(M2,1))
                 minlen = size(M1,1);
                 maxlen = size(M2,1);                 
             else
                 minlen = size(M2,1);
                 maxlen = size(M1,1);
             end             
             for k = 1:size(minlen,1)%M1 M2 k bit                 
                nowvalue = nowvalue + bitxor(M1(k,i),M2(k,j));%Î»Òì»òº¯Êý
             end             
             if(size(M1,1) ~= size(M2,1))
                 nowvalue = nowvalue + abs(size(M1,1) - size(M2,1));
             end
             if(nowvalue < minvalue)
                 minvalue = nowvalue;                 
             end
         end
         PD = PD + minvalue;         
     end


end