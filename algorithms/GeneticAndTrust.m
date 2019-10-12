function fitter = GeneticAndTrust(Z,frequency,cellName)

% richiama genetico
% prendi i parametri migliori
% fitta con deterministico
% analizza intervallo di confidenza
% se l'intervallo supera la tolleranza ripeti tutto

okFitting = false;
lb = [0.0 0.0 0.0 -1.0 0.0 0.0];
ub = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 1.0];
ub = [20 20 20 5 20 40];
ub = [];
lb = [];
while okFitting == false
    environment = [Z , frequency];
    start = genetico(lb,ub,environment)
    fitter = ImpedanceCurveFitter();
    fitter.loadData(real(Z),imag(Z),frequency, cellName);
    fitter.fit(start,lb,ub,1,1,false);
    confidence = fitter.ConfidenceIntervals;
    
    okFitting = checkIntervals(fitter.Params, confidence)
    fitter.Params
    fitter.ConfidenceIntervals
    
end
end


function outcome = checkIntervals(params, conf)
    
    outcome = true;
    for i=1:length(params)
       perc =  abs(conf(i,1)-conf(i,2))/params(i)*100;
       if isnan(perc) || perc > 40
           outcome = false;
       end
    end
end

function params = genetico(lb,ub,environment)
% ub = [4 ; 4 ; 3.0 ; 3.0 ; 4 ; 8.0];
VFitnessFunction = @(x) objectiveSalvatore(x,environment);
numberOfVariables = 6;
options = optimoptions(@ga,'PopulationSize',400,'MaxTime',180,'MaxGenerations',2000,'CrossoverFraction',0.8,'CrossoverFcn',@crossovertwopoint,'EliteCount',4,'SelectionFcn',@selectiontournament,'FunctionTolerance',10e-6);
[x,fval,EXITFLAG,OUTPUT] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options);
params = x;


% params = [0.03,0.16,0.17,0.70,0.07,0.28];

end