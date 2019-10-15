classdef TestW4Sept
    
    methods(Static)
        
        % [x, fval] = searchGlobally(fullData{1,1}.FrequencyHz,-fullData{1,1}.realPartOfImpedance,-fullData{1,1}.imagPartOfImpedance);
        
        function fitCleanAndNoisy()
            % [Znoise, Zclean] = generateOneWithNoise(fullData{2,3}.minparams, fullData{2,1}.FrequencyHz,45);
            
            load('fuelStarv.mat');
            lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
            upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
            amountOfData = 2000;
            data = generateUniformData(lowerBound, upperBound,amountOfData);
            result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
            [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time] = fitMultiple(-real(Zclean),-imag(Zclean),fullData{2,1}.FrequencyHz,lowerBound,upperBound,data);
            smallestResid = result.resid(result.index)
            dataSize = length(fullData{2,1}.FrequencyHz);
            rmse = sqrt(smallestResid/dataSize)
            
            result2 = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
            [result2.resid,result2.conf,result2.params,result2.minparams,result2.index,result2.outReason,result2.time] = fitMultiple(-real(Znoise),-imag(Znoise),fullData{2,1}.FrequencyHz,lowerBound,upperBound,data);
            smallestResid = result2.resid(result.index)
            dataSize = length(fullData{2,1}.FrequencyHz);
            rmse = sqrt(smallestResid/dataSize)
            
            
            % save('fuelStarv.mat','Zclean','Znoise');
            
        end
        
        
        function correctPercentage = getCorrectPercentage(fullData)
            bestParams = zeros(5,6);
            correctPercentage = zeros(5,1);
            for i=1:size(fullData,1)
                tolerance = 0.02;
                bestParams(i,:) = fullData{i,3}.minparams;
                smallestResid = fullData{i,3}.resid(fullData{i,3}.index);
                upperLimit = smallestResid*(1+tolerance);
                lowerLimit = smallestResid*(1-tolerance);
                count = 0;
                residuals = fullData{i,3}.resid;
                for j=1:length(residuals)
                    if residuals(j)>= lowerLimit && residuals(j) <= upperLimit
                        count = count+1;
                    end
                end
                correctPercentage(i) = count/length(residuals);
            end
        end
        
        function showResidual(fullData)
            for i=1:size(fullData,1)
                i
                smallestResid = fullData{i,3}.resid(fullData{i,3}.index)
                dataSize = length(fullData{i,1}.FrequencyHz);
                rmse = sqrt(smallestResid/dataSize)
                
            end
        end
        
        function fullData = loadFullData()
            
            amount = 10000;
            fullData = cell(5,3);
            updated = false;
            
            %%%%%%%%%%%%
            
            if exist('test_w4_sept_data.mat','file') == 2 && updated == false
                load('test_w4_sept_data.mat');
            else
                addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/normal');
                normal = load('40A_c00.mat');
                fullData{1,1} = normal;
                
                addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/fuelStarv');
                fuelStarv = load('15A_c00fuelstarv.mat');
                fullData{2,1} = fuelStarv;
                
                addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/cathodeStarv');
                cathodeStarv = load('25A_c00cathodeStarv.mat');
                fullData{3,1} = cathodeStarv;
                
                addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/anodeStarv');
                anodeStarv = load('40A_c00(prima).mat');
                fullData{4,1} = anodeStarv;
                
                addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/airStarv');
                airStarv = load('15A_c00AirStarv(ultimacart).mat');
                airStarv.FrequencyHz = airStarv.FrequencyHz(2:end);
                airStarv.realPartOfImpedance = airStarv.realPartOfImpedance(2:end);
                airStarv.imagPartOfImpedance = airStarv.imagPartOfImpedance(2:end);
                fullData{5,1} = airStarv;
                
                
                
                % per ogni cella devo fare:
                % genera 10000 random
                % fitta con tutti i 10000 (e ritorna i dati)
                % trova percentuale di fitting andati bene
                % trova il fitting migliore in base al residuo
                % di quel fitting salvati: parametri, residuo
                lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
                upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
                amountOfData = 200;
                data = generateUniformData(lowerBound, upperBound,amountOfData);
                for c=1:size(fullData,1)
                    fullData{c,2} = data;
                    realPartOfImpedance = fullData{c,1}.realPartOfImpedance;
                    imagPartOfImpedance = fullData{c,1}.imagPartOfImpedance;
                    FrequencyHz = fullData{c,1}.FrequencyHz;
                    result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
                    [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time] = fitMultiple(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,lowerBound,upperBound,fullData{c,2});
                    fullData{c,3} = result;
                end
                save('test_w4_sept_data.mat','fullData')
            end
            
        end
    end
end
