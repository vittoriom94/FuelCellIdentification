function [fitter, counter,geneticParams] = GeneticAndTrust(Z,frequency,cellName,function_model,lb,ub)

% folder = fileparts(which(mfilename));
% addpath(genpath(folder));
% richiama genetico
% prendi i parametri migliori
% fitta con deterministico
% analizza intervallo di confidenza
% se l'intervallo supera la tolleranza ripeti tutto

fprintf('Genetico... ');
% okFitting = false;
environment = [Z , frequency];
geneticParams = genetico(lb,ub,environment,function_model);
start = geneticParams;
fprintf('OK\nDeterministico: ');
fitter = ImpedanceCurveFitter();
fitter.loadData(real(Z),imag(Z),frequency, cellName);
fitter.fit(start,lb,ub,1,1,false,function_model);
% fitter.Params
confidence = fitter.ConfidenceIntervals;

okFitting = checkIntervals(fitter.Params, confidence);
counter = 1;
limit = 10000;
while okFitting == false && counter < limit
    fprintf('%d ',counter);
    %     start = genetico(lb,ub,environment,function_model,numvar)
    %     fitter = ImpedanceCurveFitter();
    %     fitter.loadData(real(Z),imag(Z),frequency, cellName);
    fitter.fit(start,lb,ub,1,1,false,function_model);
    confidence = fitter.ConfidenceIntervals;
    
    okFitting = checkIntervals(fitter.Params, confidence);
%     fitter.Params
%     fitter.ConfidenceIntervals
    start = getNewParams(fitter.Params,lb,ub);
    counter= counter+1;
end
fprintf('OK\n');
end

function params = getNewParams(params,lb,ub)
% variation = 1+(rand(1,length(params))-0.5)*0.4; %+-20%
% params = params.*variation;

variation = 0.4*rand(1,length(params))-0.2;
for i=1:length(params)
   newParam = params(i)+params(i)*variation(i);
   if newParam < lb(i) || newParam > ub(i)
       newParam = params(i)+params(i)*(-variation(i));
   end
   params(i) = newParam;
    
end

% params = params+params.*variation;

end

function outcome = checkIntervals(params, conf)

outcome = true;
for i=1:length(params)
    perc =  abs(conf(i,1)-conf(i,2))/params(i)*100;
    if isnan(perc) || perc > 80
        outcome = false;
    end
end
end

function params = genetico(lb,ub,environment,function_model)

VFitnessFunction = @(x) fitnessFunctionNormalizzata(function_model,x,environment);
numberOfVariables = length(ub);
options = optimoptions(@ga,'PopulationSize',400,'MaxTime',180,'MaxGenerations',4000,'CrossoverFraction',0.8,'CrossoverFcn',@crossovertwopoint,'EliteCount',4,'SelectionFcn',@selectiontournament,'FunctionTolerance',10e-6,'Display','off');
[x] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);
params = x;

end