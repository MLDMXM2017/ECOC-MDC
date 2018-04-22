function Acc = get_Acc(x)
Acc = []
for i = 1:size(x,2)
    temp = x{1,i};
    Acc = [Acc temp(1)];
end
end