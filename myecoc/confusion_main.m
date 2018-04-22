
Y=dcplx{4,4};
isLabels = unique(Y);
nLabels = numel(isLabels);


for i=1:9

    oofLabel = dcplx{4,3}{1,i};
    ConfMat = confusionmat(Y,oofLabel);

    % Convert the integer label vector to a class-identifier matrix.
    [~,grp] = ismember(oofLabel,isLabels);
    oofLabelMat = zeros(nLabels,n);
    idxLinear = sub2ind([nLabels n],grp,(1:n)');
    oofLabelMat(idxLinear) = 1; % Flags the row corresponding to the class
    YMat = zeros(nLabels,n);
    idxLinearY = sub2ind([nLabels n],grp,(1:n)');
    YMat(idxLinearY) = 1;

    figure;
    plotconfusion(YMat,oofLabelMat);
    h = gca;
    h.XTickLabel = [num2cell(isLabels); {''}];
    h.YTickLabel = [num2cell(isLabels); {''}];
    
    saveas(gcf ,['confusion_',num2str(i)],'fig');
    saveas(gcf ,['confusion_',num2str(i)],'tiff');
    
end
