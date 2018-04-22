function SelCh=mutation(SelCh,MutRate)

if nargin <2
    MutRate=1;
end
[Nind, Nvar]=size(SelCh);
Nvar=Nvar-1;
%%%%%%%%%%%%%% perform mutation 
MutRate=MutRate/Nvar;
%%%%% take the chromosome into two parts: one for the number of ICsets, one
%%%%% for the feature mask;
tempchild2 = SelCh(:,2:end) + (rand(Nind, (Nvar)) < MutRate);
tempchild2 = rem(tempchild2, 2);
tempchild1 = SelCh(:,1)+ (rand(Nind,1) < MutRate)*50;
tempchild1(find(tempchild1>50),1)=tempchild1(find(tempchild1>50),1)-50;
SelCh=[tempchild1 tempchild2];
