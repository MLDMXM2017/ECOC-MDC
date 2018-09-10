%##########################################################################

% <ECOC-MDC. Coding and decoding designs for multi-class problems.>
% Copyright of Machine Learning and Data Mining Team of Xmu university in China

%##########################################################################

% this is a ECOC train file

%##########################################################################

function result = ECOC_train(TD,TL,TTD,TTL,Params)   
    if isempty(strfind(Params.coding,'MDC')) == 0
        % coding is ECOC MDC
        total_cls_num = size(unique(TL),1);
        [ECOC,Cplx] = get_cds(TD,TL,total_cls_num,Params.DC);
        Params.custom_coding = ECOC;        
        [Classifiers,Train_Params] = ECOCTrain(TD,TL,Params);        
    else       
        % coding is not ECOC MDC
        % for example:DECOC,ECOCONE,ForestECOC and others
        [Classifiers,Train_Params] = ECOCTrain(TD,TL,Params);      
    end
    % ECOC predict process
    [Predict_label,~,Confusion] = ECOCTest(TTD,Classifiers,Train_Params,TTL);
   
    clear result
    result.Params = Train_Params;
    result.Classifiers = Classifiers;
    result.Predict_label = Predict_label;
    result.Confusion = Confusion;
    result.Evaluation = Fscore(TTL,Predict_label);
    if isempty(Cplx) == false
        result.Cplx = Cplx;
    end   
end