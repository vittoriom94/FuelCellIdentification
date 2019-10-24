clc
clearvars
close all

if(~isdeployed)
    cd(fileparts(which(mfilename)));
end

addpath(genpath('.'));


addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/normal');
                
load('40A_c00.mat');

lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0; 0.0; 0.0];
upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0; 10.0; 10.0];
amountOfData = 2000;
data = generateUniformData(lowerBound, upperBound,amountOfData);
result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time] = fitMultiple(-realPartOfImpedance,-imagPartOfImpedance,FrequencyHz,lowerBound,upperBound,1,1,data);
smallestResid = result.resid(result.index)
dataSize = length(FrequencyHz);
rmse = sqrt(smallestResid/dataSize)

%%
ub = upperBound;
lb = lowerBound;
param1 = {1,'Romega',lb(1),ub(1)};
param2 = {2,'Rct',lb(2),ub(2)};
param3 = {3,'Q',lb(3),ub(3)};
param4 = {4,'phi',lb(4),ub(4)};
param5 = {5,'Rd',lb(5),ub(5)};
param6 = {6,'tauD',lb(6),ub(6)};
param7 = {7,'R',lb(7),ub(7)};
param8 = {8,'C',lb(8),ub(8)};

manipulate({@(x,param) Fouquet_RC_Model(param,x),FrequencyHz,result.minparams},{[0.025,0.25],[-0.01,0.05]},-realPartOfImpedance,-imagPartOfImpedance,param1,param2,param3,param4,param5,param6,param7,param8)




function fitSimulata()

% Test su una curva generata
% 1. carica curva simulata
load('test_w4_sept_data.mat');
freq = fullData{1,1}.FrequencyHz;
Z = FouquetModel(fullData{1,3}.minparams,freq);

impedance = struct('realPartOfImpedance',real(Z),'imagPartOfImpedance',imag(Z),'FrequencyHz',freq);
normalSimulata = cell(1,7);
normalSimulata{1,1} = impedance;
normalSimulata{1,2} = fullData{1,2};

% 2. fitta curva simulata con tutti i fitting
% 2.1 dichiara fattori e dativari
realPartOfImpedance = normalSimulata{1,1}.realPartOfImpedance;
imagPartOfImpedance = normalSimulata{1,1}.imagPartOfImpedance;

lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
v1 = [ones(24,1);linspace(0.8, 0.2, 24)'];
v2 = [ones(24,1);linspace(0.8, 0.2, 22)'; zeros(2,1)];
v0 = 1;
v3 = 1/max(abs(realPartOfImpedance));
v3Imag = 1/max(abs(imagPartOfImpedance));
v4 = 1./realPartOfImpedance;
v4Imag = 1./imagPartOfImpedance;



factors = {v0; v1; v2; v3; v4};
factorsImag = {v0;v1;v2;v3Imag;v4Imag};

FrequencyHz = freq;
% cicla sui vari fitters
for f=3:length(factors)+2
    result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
    [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
        fitMultiple(realPartOfImpedance,imagPartOfImpedance,...
        FrequencyHz,lowerBound,upperBound,factors{f-2},factorsImag{f-2},normalSimulata{1,2});
    result.factors = {factors{f-2},factorsImag{f-2}};
    normalSimulata{1,f} = result;
end
save('normalSimulata.mat','normalSimulata');
% 3. intervalli

ci = ConfidenceIntervals.getIntervals(normalSimulata{1,3});

% 4. curve iniziali

saveFiguresForStartingCondition(normalSimulata,{ci});

% 5. parametri iniziali

f = showParameters(normalSimulata,ci);
saveas(f,'images/parametri/Parametri_Normal_simulata.jpg');
end