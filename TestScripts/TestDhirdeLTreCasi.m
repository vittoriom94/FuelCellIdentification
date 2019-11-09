clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));



imagesStruct = {
    '170405_1320_dt46_nc_eis-40a_c02.jpg';
    '170206_1410_dt46_nc_eis-40a_c00.jpg';
    '170206_1250_dt46_nc_eis-15a_c00.jpg'};
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
chosenImages = dataset.classifiedImages;
% fit tre casi con DhirdeL e Dhirde
% caso 1. tre gobbe e alta freq positiva
% caso 2. tre gobbe e alta freq negativa
% caso 3. due gobbe e alta freq negativa


% carica le tre impedenze

% fitta, mostra, salva


models = {'Dhirde','DhirdeL','DhirdeCL'};
amount = 3000;
for m=1:length(models)
    [ ~, lowerBound, upperBound ] = set_model_and_bound(models{m});
    start(m) = {generateUniformData(lowerBound, upperBound,amount)} ;
    
end
fittingSet = struct('data',[],'name',[],'models',[],'params',[],'resid',[],'time',[]);
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
        time(m) = {result.time};
        %         newZ = model(result.minparams,freq);
        %         newZ = model(fittingSet(i).params{m},freq);
        %         Z{2*m +1} = real(newZ);
        %         Z{2*m +2} = imag(newZ);
    end
    fittingSet(i).params = params;
    fittingSet(i).models = models;
    fittingSet(i).resid = resid;
    fittingSet(i).time = time;
    %     f = ShowData.showByZ('',[{'Sperimentale'} models],Z);
    %     saveas(f,['images/50fitting/' battery.name],'jpg');
    %     close(f);
    % ora devo salvare il risultato su grafico
end