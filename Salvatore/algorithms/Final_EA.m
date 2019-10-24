clear all
close all
clc

folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

%% Caricare file e Environment
%load ('../Tesi/ImportData/NormalCondition/170206_1250_DT46_NC_EIS_15Aprocessed/c00.mat')
Z = realPartOfImpedance+1i*imagPartOfImpedance;
environment = [Z , FrequencyHz];

%% MODELLI A DISPOSIZIONE: 
% Fouquet
% Dhirde
% Asghari
% R4C3
% FouquetRC
% CompleteAnodeCathode
% SimplifiedAnodeCathode
name_model = 'Fouquet';
[model,numvar,lb,ub] = set_model_and_bound(name_model);

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
MaxGenerations = 10000;
CrossoverFraction = 0.8;
MaxTimeSingleExecution = 360; % Seconds
EliteCount = 4;

NumeroEsecuzioni = 100;

info = struct('generations',cell(1,NumeroEsecuzioni),'message',cell(1,NumeroEsecuzioni),'populations',cell(1,NumeroEsecuzioni),'bestInd',cell(1,NumeroEsecuzioni),'fobj',cell(1,NumeroEsecuzioni),'RMSE',cell(1,NumeroEsecuzioni),'time',cell(1,NumeroEsecuzioni));
options = optimoptions(@ga,'PopulationSize',PopulationSize,'MaxTime',MaxTimeSingleExecution,'MaxGenerations',MaxGenerations,'CrossoverFraction',CrossoverFraction,'CrossoverFcn',@crossovertwopoint,'EliteCount',EliteCount,'SelectionFcn',@selectiontournament,'FunctionTolerance',FunctionTolerance); %,'PlotFcn',{'gaplotbestf'}

parfor i = 1 : NumeroEsecuzioni
    tic;
    VFitnessFunction = @(x) fit_function(model,x,environment);
    numberOfVariables = numvar;
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
