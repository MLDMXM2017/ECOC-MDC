%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 计算testlabel和predict label的正确率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    
       