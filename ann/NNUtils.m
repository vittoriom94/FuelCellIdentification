classdef NNUtils < handle
    methods (Static)
        function trainSet = getTrainSet(Z,classes,total,trainAmount)
            trainSet = [];
            for i=1:classes
                trainSet = [trainSet Z((i-1)*total+1:((i-1)*total+trainAmount),:)'];
            end
            
        end
        function targets = getTargets(results,classes,total,trainAmount)
            targets = [];
            for i=1:classes
                targets = [targets results(:,(i-1)*total+1:((i-1)*total+trainAmount))];
            end
        end
        function testingSet = getTestingSet(Z,classes,total,startFrom)
            testingSet = [];
            for i=1:classes
                testingSet = [testingSet Z((i-1)*total+startFrom+1:((i)*total),:)'];
            end
            
        end
        function [Z,Zcluster,results] = generateTestingData(Model,amount,classes,class,params,freq,noise,noiseModel)
            Z = cell(amount,1);
            for i=1:length(Z)
                
                Z{i,1} = normalize(generateOneWithNoise(Model,params(i,:),freq,noise,noiseModel));
                
                Zcluster(i,:) = [real(cell2mat(Z(i,1))') imag(cell2mat(Z(i,1))')];
                res = zeros(classes,1);
                res(class,1) = 1;
                results(:,i)=res;
                
            end
            
        end
        function verifyResults(classes,total,trainAmount,classesAmount,classVerified)
            ok=0;
            for i=(classVerified-1)*(length(classes)/classesAmount)+1:(classVerified)*(length(classes))/classesAmount
                if classes(i)==classVerified
                    ok=ok+1;
                else
                    fprintf('[%d; %d] - %d - %d \n',i+trainAmount-(classVerified-1)*(total-trainAmount),classVerified,i, classes(i));
                end
            end
            disp(["result is: " num2str(ok)]);
        end
        
    end
    
    
end