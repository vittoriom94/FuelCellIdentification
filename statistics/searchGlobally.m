function [x, fval] = searchGlobally(freq,realPart,imagPart)

 lowerBound = [-10.0 ; -10.0 ; -10.0 ; -1.0 ; -10.0 ; -10.0];
 upperBound = [20.1 ; 20.5 ; 21.0 ; 1.0 ; 20.5 ; 24.0];
start = [0.05;0.25;0.5;0.5;0.25;1.0];
options = optimoptions('lsqcurvefit');
options = optimoptions(options,'MaxFunctionEvaluations', 1000);
options = optimoptions(options,'MaxIterations', 5000);
options = optimoptions(options,'FunValCheck', 'off');
options = optimoptions(options,'SubproblemAlgorithm', 'factorization');
options = optimoptions(options,'FunctionTolerance', 1e-9);
options = optimoptions(options,'OptimalityTolerance', 1e-9);
options = optimoptions(options,'Display', 'off');

predic = @(a,freq) FouquetModel(a,freq);
F=@(a,freq) [real(predic(a,freq)); imag(predic(a,freq))];
            
gs = MultiStart('UseParallel',true);

problem = createOptimProblem('lsqcurvefit','x0',start,...
    'objective',F,'options',options,...
    'ub',upperBound,'lb',lowerBound,...
    'xdata',freq,'ydata',[realPart;imagPart]);
[x, fval] = run(gs,problem,25000);

end