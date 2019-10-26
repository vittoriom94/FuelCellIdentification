clear all
close all
clc

folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

%% Caricare file e Environment
load ('curve.mat')

FrequencyHz = chosenImages(20).data.FrequencyHz;
realPartOfImpedance = chosenImages(20).data.realPartOfImpedance;
imagPartOfImpedance = chosenImages(20).data.imagPartOfImpedance;

Z = realPartOfImpedance+1i*imagPartOfImpedance;
environment = [Z , FrequencyHz];

%% MODELLI A DISPOSIZIONE: 
% Fouquet
% FouquetRC
% FouquetRCPE
% FouquetRWar
% CompleteAnodeCathode
% SimplifiedAnodeCathode
% Dhirde
% DhirdeC
% Asghari
% AsghariWar
% R4C3
% LLFin
% LLFout
name_model = 'Fouquet';
[model,lb,ub] = set_model_and_bound(name_model);

%% FUNZIONE DI FITNESS
% minimiQuadrati
% minimiQuadratiNormalizzata
% fitnessFunctionNormalizzata
% fitnessFunctionPesata
% NormalizzataValoreSperimentale
fit_function = @fitnessFunctionNormalizzata;

%% SETTAGGIO ALGORITMO

PopulationSize = 400;
FunctionTolerance = 10e-9;
MaxGenerations = 7000;
CrossoverFraction = 0.8;
MaxTimeSingleExecution = 360; % Seconds
EliteCount = 4;

NumeroEsecuzioni = 5;

info = struct('generations',cell(1,NumeroEsecuzioni),'message',cell(1,NumeroEsecuzioni),'populations',cell(1,NumeroEsecuzioni),'bestInd',cell(1,NumeroEsecuzioni),'fobj',cell(1,NumeroEsecuzioni),'RMSE',cell(1,NumeroEsecuzioni),'time',cell(1,NumeroEsecuzioni));
options = optimoptions(@ga,'PopulationSize',PopulationSize,'MaxTime',MaxTimeSingleExecution,'MaxGenerations',MaxGenerations,'CrossoverFraction',CrossoverFraction,'CrossoverFcn',@crossovertwopoint,'EliteCount',EliteCount,'SelectionFcn',@selectiontournament,'FunctionTolerance',FunctionTolerance); %,'PlotFcn',{'gaplotbestf'}

parfor i = 1 : NumeroEsecuzioni
    tic;
    VFitnessFunction = @(x) fit_function(model,x,environment);
    numberOfVariables = length(ub);
    [x,fval,EXITFLAG,OUTPUT,POPULATION] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);
    %rmse = sqrt(fval/(size(environment,1)));
    rmse = rmseNormalizzata(model,x,environment)
    toc;
    
    % Save data in struct
    info(i).generations = OUTPUT.generations;
    info(i).message = OUTPUT.message;
    info(i).populations = POPULATION;
    info(i).bestInd = x;
    info(i).fobj = fval;
    info(i).RMSE = rmse;
    info(i).time = toc;
    
    disp(i);
end

TotalTime = 0;
for j=1:length(info)
    TotalTime = TotalTime + info(j).time;
end
AverageTime = TotalTime/NumeroEsecuzioni;

%% Stampa the best Result
PlotCurves(model,info,environment);
