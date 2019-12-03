clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));
warning('off','MATLAB:singularMatrix');

curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
trainingImages = dataset.classifiedImages(1:35);
chosenImages = dataset.classifiedImages;


% fitta con l'algoritmo

% ottieni tempo di esecuzione
% ottieni modello scelto
% ottieni errore
% ottieni parametri
%%
fitter = Fitter();
dataFitAndClassTrain = fitter.fit(trainingImages,[2000 2000 2000]);
save('datiFinali/dataFitAndClassTrain.mat','dataFitAndClassTrain')
% per le convergenze, devo fare l'esecuzione su 10000/10000/10000

% QUI analizzo le convergenze con la formula inversa e calcolo i valori
% necessari
%%
convergenceAmounts =  ceil(getConvergenceAmounts(dataFitAndClassTrain));
%%


% Test Modello ottenuto
modelNames = {'DhirdeSimple','DhirdeL','DhirdeLWARL'};
resultTrain = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
amount = 2000;
for i=1:length(trainingImages)
    battery = trainingImages(i);
    freq = battery.data.FrequencyHz;
    rPart = battery.data.realPartOfImpedance;
    iPart = battery.data.imagPartOfImpedance;
%     k = dataFitAndClass(i).choice;
    % DEVO Usare sempre il modello più complesso
    [ model, lowerBound, upperBound ] = set_model_and_bound(modelNames{3});
    start = generateUniformData(lowerBound, upperBound,amount);
    % fitta
    
    [resultTrain(i).resid,resultTrain(i).conf,resultTrain(i).params,resultTrain(i).minparams,resultTrain(i).index,resultTrain(i).outReason,resultTrain(i).time,resultTrain(i).initialResid] = ...
        fitMultiple(rPart,iPart,...
        freq,lowerBound,upperBound,1,1,start,model);

end
save('datiFinali/resultTrain.mat','resultTrain')
% fitta 10000 volte
% ottieni tempo di esecuzione medio, min, max
% ottieni convergenza
% ottieni RMSE
%%
dataFitAndClass = fitter.fit(chosenImages,convergenceAmounts);
%%
precision = 0.999999;
requiredLaunchesForced = 0;
count = 0;
total = 0;
for i=1:length(trainingImages)
    convergence = ImpedanceGroups.getConvergence(result(i),modelNames{3},chosenImages(i).data.FrequencyHz)
    requiredLaunchesForced = max([requiredLaunchesForced log(1-precision)/log(1-convergence)]);
    
    count=count+1;
    total = total+amount*convergence;
           
end
requiredLaunchesForcedAverage = log(1-precision)/log(1-total/(count*amount));

comparison = struct('model',[],'minTime',[],'maxTime',[],'avgTime',[],'totTime',[],'reqTrials',[],'rmseNorm',[]);
for i=1:length(chosenImages)

    m = dataFitAndClass(i).choice;

    
    convergence = ImpedanceGroups.getConvergence(result(i),modelNames{3},chosenImages(i).data.FrequencyHz);
        
    comparison(i).model = m;
    comparison(i).minTime = [dataFitAndClass(i).times(m,1) min(cell2mat(result(i).time))];
    comparison(i).maxTime = [dataFitAndClass(i).times(m,2) max(cell2mat(result(i).time))];
    comparison(i).avgTime = [dataFitAndClass(i).times(m,3) mean(cell2mat(result(i).time))];
    totTime = 0;
    for k=1:m
        totTime = totTime + convergenceAmounts(k)*dataFitAndClass(i).times{k,3};
    end
    comparison(i).totTime = [totTime requiredLaunchesForcedAverage*mean(cell2mat(result(i).time)) requiredLaunchesForced*mean(cell2mat(result(i).time))];
    comparison(i).reqTrials = [convergenceAmounts(m) log(1-precision)/log(1-convergence)];
    modelForced = set_model_and_bound(modelNames{3});
    modelAlg = set_model_and_bound(modelNames{m});
    rmseSu10000 = RMSEED(chosenImages(i).data.realPartOfImpedance, chosenImages(i).data.imagPartOfImpedance, real(modelForced(result(i).minparams,chosenImages(i).data.FrequencyHz)), imag(modelForced(result(i).minparams,chosenImages(i).data.FrequencyHz)));
    rmseAlgoritmo = RMSEED(chosenImages(i).data.realPartOfImpedance, chosenImages(i).data.imagPartOfImpedance, real(modelAlg(dataFitAndClass(i).params{m},chosenImages(i).data.FrequencyHz)), imag(modelAlg(dataFitAndClass(i).params{m},chosenImages(i).data.FrequencyHz)));
    
    comparison(i).rmseNorm = [ rmseAlgoritmo rmseSu10000 ];
end
%%
save('testValidationStrict.mat','dataFitAndClassTrain','dataFitAndClass','result','comparison');

function convergenceAmounts = getConvergenceAmounts(dataFitAndClass)
amount = 2000;
precision = 0.999999;

for i=1:3
    count = 0;
    total = 0;
    for j=1:length(dataFitAndClass)

            count=count+1;
            total = total+amount*dataFitAndClass(j).convergences{i};

        
    end
    convergenceAmounts(i,1) = log(1-precision)/log(1-total/(count*amount));
end


end







