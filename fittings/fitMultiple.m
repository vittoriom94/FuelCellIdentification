function [resid,conf,params,minparams,index,outReason, time,initialResid] = fitMultiple(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,lowerBound,upperBound,realFactor,imagFactor,estim,model)

for i = 1:size(estim,1)
%     i
    fitter = ImpedanceCurveFitter();
    fitter.loadData(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,'Normal condition');
    fitter.fit(estim(i,:),lowerBound,upperBound,realFactor,imagFactor,false,model);
    resid(i,1) = fitter.Resnorm;
    conf{i,1} = fitter.ConfidenceIntervals;
    params{i,1} = fitter.Params;
    outReason{i,1} = fitter.ExitFlag;
    time{i,1} = fitter.Time;
    initialResid{i,1} = initialResidual( (realPartOfImpedance+1i*imagPartOfImpedance), FouquetModel(estim(i,:),FrequencyHz),realFactor,imagFactor);
end

% [res,conf] = fittingDatiBassoRosa();
[M,index] = min(resid);
minparams = params{index};
% minparams = [0.0537    0.1036    0.1141    0.7640    0.0638    0.3511];
% generati = FouquetModel(minparams,FrequencyHz);
% showFittedData(-realPartOfImpedance,-imagPartOfImpedance,real(generati),imag(generati),'Normal',false);


end