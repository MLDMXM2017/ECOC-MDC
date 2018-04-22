function scatplot1(x,y)

[M N]=size(x);

maxx=max(x);
minx=min(x);
maxy=max(y);
miny=min(y);
tj=zeros(401,401);  %经各种算我的数据分成400比较正好。x,y都将近9万个数。图像得到的。
xfd=(maxx-minx)/400;
yfd=(maxy-miny)/400;
for i=1:M
    i_tmp=int32((x(i)-minx)/xfd)+1;
    j_tmp=int32((y(i)-miny)/yfd)+1;
    tj(i_tmp,j_tmp)=tj(i_tmp,j_tmp)+1;
end

tjmax=max(max(tj));  %我程序需要找出最大值
[i,j]=find(tj==tjmax);

i=mean(i) ;%因为最大值不只一个，取个平均。因为我不需要那个确切的点。
j=mean(j);

image(tj)

end