classdef NNUtils < handle
    methods (Static)
        function trainSet = getTrainSet(Z,classes,total,trainAmount)
            trainSet = [];
            
            for i=1:classes
                totalSum = sum(total(1:i));
                trainSet = [trainSet Z(totalSum+1:(totalSum+trainAmount(i)),:)'];
                
                
            end
            
        end
        function targets = getTargets(results,classes,total,trainAmount)
            targets = [];
            for i=1:classes
                totalSum = sum(total(1:i));
                targets = [targets results(:,totalSum+1:(totalSum+trainAmount(i)))];
            end
        end
        function testingSet = getTestingSet(Z,classes,total,startFrom)
            testingSet = [];
            for i=1:classes
                totalSum = sum(total(1:i));
                totalSumEnd = sum(total(1:i+1));
                testingSet = [testingSet Z(totalSum+startFrom(i)+1:(totalSumEnd),:)'];
            end
            
        end
        function [Z,Zcluster,results] = generateTestingData(Model,amount,classes,class,params,freq,noise,noiseModel)
            Z = cell(amount,1);
            
            res = zeros(classes,1);
            res(class,1) = 1;
            for i=1:length(Z)
                Z{i,1} = NNUtils.normalize(generateOneWithNoise(Model,params(i,:),freq,noise,noiseModel));
                Zcluster(i,:) = [real(cell2mat(Z(i,1))') imag(cell2mat(Z(i,1))')];
                results(:,i)=res;
                
            end
            
        end
        function [Z,Zcluster,results] = generateTestingDataAugmentation(Model,amount,trainAmount,base,classes,class,params,freq,noise,noiseModel)
            Z = cell(amount,1);
            Zaug = {};
            res = zeros(classes,1);
            res(class,1) = 1;
            for j=1:base
                Zbase = generateOneWithNoise(Model,params(j,:),freq,noise,noiseModel);
                Zaug = generateFromImpedance(Zbase,trainAmount/base);
                for k=1:size(Zaug,1)
                    Z{(j-1)*size(Zaug,1)+k,1} = NNUtils.normalize(Zaug{k,1});
                    Zcluster((j-1)*size(Zaug,1)+k,:) = [real(cell2mat(Z((j-1)*size(Zaug,1)+k,1))') imag(cell2mat(Z((j-1)*size(Zaug,1)+k,1))')];
                    results(:,(j-1)*size(Zaug,1)+k)=res;
                    
                end
                
            end
            for i=trainAmount+1:length(Z)
                Z{i,1} = NNUtils.normalize(generateOneWithNoise(Model,params(i,:),freq,noise,noiseModel));
                Zcluster(i,:) = [real(cell2mat(Z(i,1))') imag(cell2mat(Z(i,1))')];
                results(:,i)=res;
                
            end
            
        end
        function [Z,Zcluster] = augment(Z,Zcluster, amount, trainAmount, base)
            classes=3;
            step = floor(trainAmount/base);
            for i=1:classes
                a=1;
                for j=1:base
                    Zbase = Z{(j-1)*step+1,i};
                    Zaug = generateFromImpedance(Zbase,step);
                    for k=1:size(Zaug,1)
                        Z{(j-1)*size(Zaug,1)+k,i} = NNUtils.normalize(Zaug{k,1});
                        Zcluster((i-1)*(j-1)*size(Zaug,1)+k+(i-1)*amount,:) = [real(cell2mat(Z((j-1)*size(Zaug,1)+k,i))') imag(cell2mat(Z((j-1)*size(Zaug,1)+k,i))')];
                        
                    end
                    
                end
            end
            
        end
        function [Z,Zcluster,results,total,trainAmount] = augmentExisting(Z,Zcluster,results, total, trainAmount, mult)
            
            for i=1:length(trainAmount)
                Zaug = {};
                ZaugCluster = [];
                resAug = [];
                res = zeros(3,1);
                res(i,1) = 1;
                for j=1:trainAmount(i)
                    newZ = generateFromImpedance(Z{j+sum(total(1:i))},mult);
                    for k=1:size(newZ,1)
                        newZ{k,1} = NNUtils.normalize(newZ{k,1});
                        resAug = [resAug res];
                    end
                    Zaug = [Zaug;newZ];
                    toMat = cell2mat(newZ')';
                    ZaugCluster = [ZaugCluster; real(toMat) imag(toMat)];
                    
                    
                end
                if trainAmount(i) > 0
                    startInd = sum(total(1:i)) + trainAmount(i);
                    Z = [Z(1:startInd,1); Zaug; Z(startInd+1:end,1)];
                    Zcluster = [Zcluster(1:startInd,:); ZaugCluster; Zcluster(startInd+1:end,:)];
                    results = [results(:,1:startInd) resAug results(:,startInd+1:end)];
                end
                total(i+1) = (total(i+1)-trainAmount(i))+trainAmount(i)*mult;
                trainAmount(i) = trainAmount(i)*mult;
                
                
            end
            
            
        end
        function wrongs = verifyResults(classes,total,trainAmount,classesAmount,classVerified)
            ok=0;
            wrongs = zeros(0,3);
            
            if classVerified == 1
                startTests = 1;
            else
                startTests = 1+total(classVerified)-trainAmount(classVerified-1);
            end
            endTests = sum(total(2:classVerified+1)-trainAmount(1:classVerified));
            %                 endTests = total(classVerified+1)-trainAmount(classVerified);
            for i=startTests:endTests
                %             for i=(classVerified-1)*(length(classes)/classesAmount)+1:(classVerified)*(length(classes))/classesAmount
                if classes(i)==classVerified
                    ok=ok+1;
                else
                    number = i+trainAmount(classVerified)-startTests+1;
                    fprintf('[%d; %d] - %d - %d \n',number,classVerified,i, classes(i));
                    wrongs(end+1,:) = [number, classVerified, classes(i)];
                end
            end
            wrong = total(classVerified+1)-trainAmount(classVerified)-ok;
            fprintf('\nCurve sbagliate: %d, perc: %.2f\n',wrong,wrong/(total(classVerified+1)-trainAmount(classVerified))*100);
            disp(["result is: " num2str(ok)]);
        end
        function impedance = normalize(impedance)
            Zr = real(impedance);
            Zi = imag(impedance);
            
            minR = min(Zr);
            minI = max(Zi);
            Zr = Zr-minR;
            %             Zi = Zi-minI;
            
            maxR = max(abs(Zr));
            maxI = max(abs(Zi));
            %     minI = min(abs(Zi);
            impedance = (Zr/maxR)+1i*(Zi/maxI);
            
        end
        function Z = generateFromBase(Zbase, amount)
            newZ = generateFromImpedance(Zbase,amount);
            
        end
    end
    
    
end