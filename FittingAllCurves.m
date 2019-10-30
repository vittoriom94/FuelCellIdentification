clear all
close all
clc

folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

load ('curve.mat')

%SETTAGGIO ALGORITMO
PopulationSize = 400;
FunctionTolerance = 10e-9;
MaxGenerations = 7500;
CrossoverFraction = 0.8;
MaxTimeSingleExecution = 300; % Seconds
EliteCount = 4;

NumeroEsecuzioni = 300;

alldata = struct('curva',1);
for p = 1 : length(chosenImages)
      FrequencyHz = chosenImages(p).data.FrequencyHz;
      realPartOfImpedance = chosenImages(p).data.realPartOfImpedance;
      imagPartOfImpedance = chosenImages(p).data.imagPartOfImpedance;

      Z = realPartOfImpedance+1i*imagPartOfImpedance;
      environment = [Z , FrequencyHz];
      
      data = struct('dati',1);
      for m = 1 : 4
          if(m == 1)
              name_model = 'Fouquet';
          elseif(m == 2)
              name_model = 'FouquetRC';
          elseif(m == 3)
              name_model = 'DhirdeCL';
          elseif(m == 4)
              name_model = 'Asghari';
          end

          [model,lb,ub] = set_model_and_bound(name_model);
          fit_function = @fitnessFunctionNormalizzata;
          
          info = struct('model',cell(1,NumeroEsecuzioni),'bestInd',cell(1,NumeroEsecuzioni),'fobj',cell(1,NumeroEsecuzioni),'RMSE',cell(1,NumeroEsecuzioni),'time',cell(1,NumeroEsecuzioni),'generations',cell(1,NumeroEsecuzioni),'message',cell(1,NumeroEsecuzioni));
          options = optimoptions(@ga,'PopulationSize',PopulationSize,'MaxTime',MaxTimeSingleExecution,'MaxGenerations',MaxGenerations,'CrossoverFraction',CrossoverFraction,'CrossoverFcn',@crossovertwopoint,'EliteCount',EliteCount,'SelectionFcn',@selectiontournament,'FunctionTolerance',FunctionTolerance);
          
          parfor i = 1 : NumeroEsecuzioni
                tic;
                VFitnessFunction = @(x) fit_function(model,x,environment);
                numberOfVariables = length(ub);
                [x,fval,EXITFLAG,OUTPUT,POPULATION] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);
                %rmse = sqrt(fval/(size(environment,1)));
                rmse = rmseNormalizzata(model,x,environment);
                toc;

                % Save data in struct
                info(i).model = name_model;
                info(i).bestInd = x;
                info(i).fobj = fval;
                info(i).RMSE = rmse;
                info(i).time = toc;
                info(i).generations = OUTPUT.generations;
                info(i).message = OUTPUT.message;

          end
          data(m).dati = info;
      end
      alldata(p).curva = data;
      disp(p);
end

%% Stampa the best Result
%PlotCurves(model,info,environment);
