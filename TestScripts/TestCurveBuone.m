clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));
% rmparth('Salvatore');

% scegliere le curve
curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
chosenImages = dataset.classifiedImages(9:9);
% chosenImages = dataset.classifiedImages;
% effettuare il fitting con i modelli diversi
models = {'DhirdeLCPEWARL'};
amount = 1000;
for m=1:length(models)
    [ ~, lowerBound, upperBound ] = set_model_and_bound(models{m});
    start(m) = {generateUniformData(lowerBound, upperBound,amount)} ;
    
end
fittingSet = struct('data',[],'name',[],'models',[],'params',[],'resid',[]);
for i=1:length(chosenImages)
    battery = chosenImages(i);
    freq = battery.data.FrequencyHz;
    rPart = battery.data.realPartOfImpedance;
    iPart = battery.data.imagPartOfImpedance;
    
    fittingSet(i).data = battery.data;
    fittingSet(i).name = battery.name;
    params = cell(1,length(models));
    resid = cell(1,length(models));
    Z = {rPart,iPart};
    for m=1:length(models)
        [ model, lowerBound, upperBound ] = set_model_and_bound(models{m});
        % fitta
        result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
        [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
            fitMultiple(rPart,iPart,...
                        freq,lowerBound,upperBound,1,1,start{m},model);
        params(m) = {result.minparams};
        resid(m) = {result.resid(result.index)};
        %         newZ = model(result.minparams,freq);
        %         newZ = model(fittingSet(i).params{m},freq);
        %         Z{2*m +1} = real(newZ);
        %         Z{2*m +2} = imag(newZ);
    end
    fittingSet(i).params = params;
    fittingSet(i).models = models;
    fittingSet(i).resid = resid;
    %     f = ShowData.showByZ('',[{'Sperimentale'} models],Z);
    %     saveas(f,['images/50fitting/' battery.name],'jpg');
    %     close(f);
    % ora devo salvare il risultato su grafico
end
% save('fittingSet.mat','fittingSet')
% salvare la struttura

%%
% per ogni curve
bestResults = cell(length(fittingSet),2);
for i=1:length(fittingSet)
    resid = 0;
    bestModel = 0;
    for j=1:length(models)
        
        newResid = fittingSet(i).resid{j};
        if j == 1 || newResid < resid
            resid = newResid;
            bestModel = j;
        end
    end
    bestResults(i,:) = {bestModel, resid};
end

%%
% save('data/fittingSetPrime10.mat','fittingSet')
