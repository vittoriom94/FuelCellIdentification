classdef MultipleFitter < handle
    properties
        realPart
        imagPart
        frequency
        amounts
        lowerBound
        upperBound
        startData
        
        residual
        confidence
        params
        outReason
        minParams
        index
    end
    methods
        function configure(obj, amounts, realPart,imagPart,frequency,lowerBound,upperBound,estim)
            obj.amounts = amounts;
            obj.realPart = realPart;
            obj.imagPart = imagPart;
            obj.lowerBound = lowerBound;
            obj.upperBound = upperBound;
            obj.frequency = frequency;
            if ismpty(estim)
                obj.startData = generateUniformData(lowerBound, upperBound,amounts);
            else
                obj.startData = estim;
            end
        end
        function loadExisting(obj, data)
            obj.realPart = -data{1,1}.realPartOfImpedance;
            obj.imagPart = -data{1,1}.imagPartOfImpedance;
            obj.frequency = data{1,1}.FrequencyHz;
            obj.startData = data{1,2};
            
            obj.residual = data{1,3}.resid;
            obj.confidence = data{1,3}.conf;
            obj.params = data{1,3}.params;
            obj.minParams = data{1,3}.minparams;
            obj.index = data{1,3}.index;
            obj.outReason = data{1,3}.outReason;
        end
        function fit(obj)
            for i = 1:obj.amounts
                %                 i
                fitter = ImpedanceCurveFitter();
                fitter.loadData(obj.realPart,obj.imagPart,obj.frequency,'');
                fitter.fit(obj.startData(i,:),obj.lowerBound,obj.upperBound,false);
                obj.residual(i,1) = fitter.Resnorm;
                obj.confidence{i,1} = fitter.ConfidenceIntervals;
                obj.params{i,1} = fitter.Params;
                obj.outReason{i,1} = fitter.ExitFlag;
                %                 time{i,1} = fitter.Time;
            end
            [~,obj.index] = min(resid);
            obj.minParams = obj.params{obj.index};
        end
        function data = getData(obj)
            data = struct('resid',obj.residual,'conf',obj.confidence,'params',obj.params','minparams',obj.minParams,'index',obj.index,'outReason',obj.outReason,'time',[]);
        end
        function [smallestResid, rmse] = getSmallestResidual(obj)
            smallestResid = obj.residual(obj.index);
            dataSize = length(obj.frequency);
            rmse = sqrt(smallestResid/dataSize);
        end
        function percentage = getCorrectPercentage(obj)
            tolerance = 0.02;
            smallestResid = obj.residual(obj.index);
            upperLimit = smallestResid*(1+tolerance);
            lowerLimit = smallestResid*(1-tolerance);
            count = 0;
            for j=1:obj.amounts
                if residuals(j)>= lowerLimit && obj.residual(j) <= upperLimit
                    count = count+1;
                end
            end
            percentage = count/length(residuals);
        end
    end
end