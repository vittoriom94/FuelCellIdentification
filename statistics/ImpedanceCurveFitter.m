classdef ImpedanceCurveFitter < handle
    properties
        MeasuredReal
        MeasuredImag
        GeneratedReal
        GeneratedImag
        Frequencies
        CellName
        StartParams
        Params
        ConfidenceIntervals
        Error
        Output
        Resnorm
        LowerBound
        UpperBound
        ExitFlag
        Time
        RealFactor
        ImagFactor
    end
    methods
        function loadData(obj,realPart,imagPart,frequency, cellName)
            obj.MeasuredReal = realPart;
            obj.MeasuredImag = imagPart;
            obj.CellName = cellName;
            obj.Frequencies = frequency;
        end
        function fit(obj, estim,lb,ub,realFactor,imagFactor,showData)
            obj.StartParams = estim;
            obj.LowerBound = lb;
            obj.UpperBound = ub;
            obj.RealFactor = realFactor;
            obj.ImagFactor = imagFactor;
            [ahat,resnorm,residual,exitflag,output,lambda,jacobian] = doFitting(obj);
            obj.Params = ahat;
            obj.Output = output;
            obj.Resnorm = resnorm;
            obj.ExitFlag = exitflag;
            % ahat = [0.0429	0.0113	0.1254	0.3693	0.0561	0.0051]
            generati = FouquetModel(obj.Params,obj.Frequencies);
            obj.GeneratedReal = real(generati);
            obj.GeneratedImag = imag(generati);
            obj.ConfidenceIntervals = nlparci(ahat,residual,'jacobian',jacobian,'alpha',0.5);
            if showData == true
                showFittedData(obj.MeasuredReal,obj.MeasuredImag,real(generati),imag(generati),obj.CellName,false);
            end
            obj.Error = RMSEED(obj.MeasuredReal,obj.MeasuredImag,real(generati),imag(generati));
            
        end
        
        function [ahat,resnorm,residual,exitflag,output,lambda,jacobian] = doFitting(obj)
            


            
            predic = @(a,freq) AsghariModel(a,freq);
            F=@(a,freq) [real(predic(a,freq)); imag(predic(a,freq))];
            
            %Esecuzione algoritmo
            options = optimoptions('lsqcurvefit');
            options = optimoptions(options,'Display', 'final-detailed');
            options = optimoptions(options,'MaxFunctionEvaluations', 1000);
            options = optimoptions(options,'MaxIterations', 5000);
            options = optimoptions(options,'FunValCheck', 'off');
            options = optimoptions(options,'SubproblemAlgorithm', 'factorization');
            options = optimoptions(options,'FunctionTolerance', 1e-9);
            options = optimoptions(options,'OptimalityTolerance', 1e-9);
            options = optimoptions(options,'Display', 'off');
            tic;
            [ahat,resnorm,residual,exitflag,output,lambda,jacobian] = ...
                lsqcurvefit(F,obj.StartParams,obj.Frequencies,[obj.MeasuredReal;obj.MeasuredImag],obj.LowerBound,obj.UpperBound,options);
            obj.Time = toc;
            
        end
        
    end
end