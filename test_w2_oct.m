clc
clearvars
close all

cd(fileparts(which(mfilename)));
addpath(genpath('.'));

data = 'test_w4_sept_data.mat';
load(data);

%% parte 1
% % verifica che il valore trovato sia in mezzo all'intervallo
% confidenceStats = ConfidenceIntervals.getAllIntervals(fullData);
% result = ConfidenceIntervals.isCentered(fullData,confidenceStats);
% mostra dati
% displayData(fullData,confidenceStats);
% salva figure
% saveFiguresForStartingCondition(fullData,confidenceStats);



%% parte 2
% fitting con altre funzioni
% lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
% upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
% amountOfData = 2000;
% data = generateUniformData(lowerBound, upperBound,amountOfData);
% rfactor = max(abs(fullData{1,1}.realPartOfImpedance));
% ifactor = max(abs(fullData{1,1}.imagPartOfImpedance));
% 
% rfactor = [ones(32,1) ; linspace(1,0.2,16)'];
% ifactor = rfactor;
% 
% result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
% [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time] = ...
%     fitMultiple(-fullData{2,1}.realPartOfImpedance,-fullData{2,1}.imagPartOfImpedance,...
%     fullData{2,1}.FrequencyHz,lowerBound,upperBound,rfactor,ifactor,data);
% smallestResid = result.resid(result.index)
% dataSize = length(fullData{2,1}.FrequencyHz);
% rmse = sqrt(smallestResid/dataSize)
% p1 = result.minparams;
% Z1 = FouquetModel(p1,fullData{2,1}.FrequencyHz);
% 
% 
% result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
% [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time] = ...
%     fitMultiple(-fullData{2,1}.realPartOfImpedance,-fullData{2,1}.imagPartOfImpedance,...
%     fullData{2,1}.FrequencyHz,lowerBound,upperBound,1,1,data(1:500,:));
% smallestResid = result.resid(result.index)
% dataSize = length(fullData{2,1}.FrequencyHz);
% rmse = sqrt(smallestResid/dataSize)
% p2 = result.minparams;
% Z2 = FouquetModel(p2,fullData{2,1}.FrequencyHz);
% 
% Z = {-fullData{2,1}.realPartOfImpedance,-fullData{2,1}.imagPartOfImpedance,...
%     real(Z1),imag(Z1),real(Z2),imag(Z2)};
% ShowData.showByZ('',{'Reale';'Norm';'1 - 1'},Z)


% fitWithWeights(fullData);
% fitNormalized(fullData);


 ci = ConfidenceIntervals.getAllIntervals(fullData);
% saveFiguresForStartingCondition(fullData,ci);
% showParameters(fullData(2,:),ci{1})
% PrintData.displayAll(fullData,ci);


% esecuzioni corrette su 1000
% for c=1:size(ci,1)
%     for f=1:size(ci,2)
%         count = 0;
%         indexes = [ci{c,f}{1,1}{:,1}];
%         for i=1:1000
%             if any(indexes == i) == 1
%                 count = count+1;
%             end
%         end
%         perc = count/1000*100;
%         percSymbol = '%';
%         fprintf("Cella %d fitting %d risultato %.2f%s (su 1000);\n\n",c,f,perc,percSymbol);
%     end
% end


% load('datiSalvatore');
% Compare.showLocalMinimums(fullData,datiSalvatore,ci);


for i=1:size(fullData,1)
    f = showParameters(fullData(i,:),ci{i,1});
    saveas(f,['images/parametri/Parametri ', num2str(i)],'jpg');
    close all;
    
end

% fitting con entrambi
% imported = importdata('curva2.csv');
% 
% data = imported.data;
% freq = data(1:48,2);
% realPart = -data(1:48,3);
% imagPart = -data(1:48,4);
% 
% figure(1)
% plot(realPart(:,1),-imagPart(:,1),'r')
% axis equal;
% grid on;
% hold on
% 
% fitter = GeneticAndTrust(realPart+1i*imagPart,freq,'curva1');
% gen = FouquetModel(fitter.Params,freq);
% plot(real(gen),-imag(gen));
% %%
% lb = [0 0 0 0 0 -20];
% ub = [0.1 0.1 10 1 0.1 20];
% minparams = fitter.Params;
% param1 = {1,'Romega',lb(1),ub(1)};
% param2 = {2,'Rct',lb(2),ub(2)};
% param3 = {3,'Q',lb(3),ub(3)};
% param4 = {4,'phi',lb(4),ub(4)};
% param5 = {5,'Rd',lb(5),ub(5)};
% param6 = {6,'tauD',lb(6),ub(6)};
% 
% manipulate({@(x,param) FouquetModel(param,x),freq,minparams},{[0.001,0.0055],[-0.0004,0.0014]},realPart,imagPart,param1,param2,param3,param4,param5,param6)





function fitNormalized(fullData)
% devo fittare senza pesi, con pesi, con gli ultimi campioni annullati
% ATTENZIONE: devo anche salvarmi il residuo iniziale, posso calcolarlo
% a parte
lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];


for c=1:size(fullData,1)
    realPartOfImpedance = -fullData{c,1}.realPartOfImpedance;
    imagPartOfImpedance = -fullData{c,1}.imagPartOfImpedance;
    FrequencyHz = fullData{c,1}.FrequencyHz;
    
    v1 = 1/max(abs(realPartOfImpedance));
    v1Imag = 1/max(abs(imagPartOfImpedance));
    v2 = 1./realPartOfImpedance;
    v2Imag = 1./imagPartOfImpedance;
    factors = { v1; v2};
    factorsImag = {v1Imag;v2Imag};
    for f=6:length(factors)+5
        result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
        [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
            fitMultiple(realPartOfImpedance,imagPartOfImpedance,...
            FrequencyHz,lowerBound,upperBound,factors{f-5},factorsImag{f-5},fullData{c,2});
        result.factors = {factors{f-5},factorsImag{f-5}};
        fullData{c,f} = result;
    end
    
end

save('test_w4_sept_data.mat','fullData')
end

function fitWithWeights(fullData)
% devo fittare senza pesi, con pesi, con gli ultimi campioni annullati
% ATTENZIONE: devo anche salvarmi il residuo iniziale, posso calcolarlo
% a parte
lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
v1 = [ones(24,1);linspace(0.8, 0.2, 24)'];
v2 = [ones(24,1);linspace(0.8, 0.2, 22)'; zeros(2,1)];
v0 = 1;
factors = {v0; v1; v2};

for c=1:size(fullData,1)
    realPartOfImpedance = -fullData{c,1}.realPartOfImpedance;
    imagPartOfImpedance = -fullData{c,1}.imagPartOfImpedance;
    FrequencyHz = fullData{c,1}.FrequencyHz;
    for f=3:length(factors)+2
        result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
        [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
            fitMultiple(realPartOfImpedance,imagPartOfImpedance,...
            FrequencyHz,lowerBound,upperBound,factors{f-2},factors{f-2},fullData{c,2});
        result.factors = {factors{f-2},factors{f-2}};
        fullData{c,f} = result;
    end
    
end

save('test_w4_sept_data.mat','fullData')
end

function displayData(fullData,confidenceStats)
graphNames = {'Normal';'Fuel Starvation';'Cathode Starvation';'Anode Starvation';'Air Starvation'};
for i=1:size(fullData,1)
    close all;
    res = fullData{i,3};
    conf = confidenceStats{i};
    fprintf('\nCella numero %d\n\n',i);
    Z=cell(1,2*size(conf,2));
    params=cell(size(conf,2),1);
    plotNames = cell(1+size(conf,2),1);
    plotNames{1,1} = 'Dati sperimentali';
    
    Z{1} = -fullData{i,1}.realPartOfImpedance;
    Z{2} = -fullData{i,1}.imagPartOfImpedance;
    for j=1:size(conf,2)
        [index, resid] = conf{1,j}{1,:};
        dataSize = 48;
        rmse = sqrt(resid/dataSize);
        displayForFile(res.params{index},conf{2,j},conf{3,j},resid,rmse);
        
    end
    
end
end