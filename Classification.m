%%
% lb = [0 0 0 0 0 0 0];
% ub = [3 3 3 3 3 3 3];
% minparams = [1 1 1 1 1 1 1];
% param1 = {1,'R1',lb(1),ub(1)};
% param2 = {2,'R2',lb(2),ub(2)};
% param3 = {3,'R3',lb(3),ub(3)};
% param4 = {4,'R4',lb(4),ub(4)};
% param5 = {5,'C1',lb(5),ub(5)};
% param6 = {6,'C2',lb(6),ub(6)};
% param7 = {7,'C3',lb(7),ub(7)};
% data = -realPartOfImpedance-1i*imagPartOfImpedance;
% manipulate({@(x,param) R4C3Model(param,x),FrequencyHz,minparams},{[0.0,1],[0.0,1]},real(data),imag(data),param1,param2,param3,param4,param5,param6,param7)
%


classdef Classification
    methods(Static)
        function [Z,Zcluster,results] = generateData(total,trainAmount,augment,base)
            addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/normal');
            load('40A_c00.mat');
            
            freq = FrequencyHz;
            
            clusters = 2;
            
            % model1 = [
            %     [0.5 0.3 0.3 0.6 0.3 0.7];
            %     [1.0 0.3 0.5 0.5 0.25 0.7];
            %     [0.05 0.4 0.25 0.4 0.2 0.9];
            %     [0.15 0.28 0.2 0.45 0.1 0.2];
            %     [0.9 0.45 0.3 0.5 0.25 0.8]
            %     ];
            %
            %
            % model2 = [
            %     [0.5 0.8 0.0001 0.0001 0.8 0.6];
            %     [1.0 0.6 0.0001 0.0001 0.5 0.9];
            %     [0.05 0.4 0.0001 0.0001 0.6 0.4 ];
            %     [0.15 0.2 0.0001 0.0001 0.7 0.75];
            %     [0.9 0.45 0.0001 0.0001 0.3 0.5]
            %     ];
            
            
            
            lb1 = [0.0 0.2 0.001];
            ub1 = [0.5 0.5 0.005];
            model1 = generateUniformData(lb1, ub1,total);
            
            
            lb2 = [0.0 0.4 0.55 0.02 0.7];
            ub2 = [0.5 0.6 0.75 0.05 1.2];
            model2 = generateUniformData(lb2, ub2,total);
            
            lb3 = [0.0 0.4 0.55 0.7 0.0005 0.02 0.7];
            ub3 = [0.5 0.6 0.75 1.0 0.004 0.05 1.2];
            model3 = generateUniformData(lb3, ub3,total);
            % f = figure
            % hold on
            if augment == true
                [Z1,Zcluster1,results1] = NNUtils.generateTestingDataAugmented(@RRCModel,total,trainAmount,base,3,1,model1,freq,0.1,2);
                [Z2,Zcluster2,results2] = NNUtils.generateTestingDataAugmented(@RRRCCModel,total,trainAmount,base,3,2,model2,freq,0.1,2);
                [Z3,Zcluster3,results3] = NNUtils.generateTestingDataAugmented(@R4C3Model,total,trainAmount,base,3,3,model3,freq,0.1,2);
                
            else
                [Z1,Zcluster1,results1] = NNUtils.generateTestingData(@RRCModel,total,3,1,model1,freq,0.1,2);
                [Z2,Zcluster2,results2] = NNUtils.generateTestingData(@RRRCCModel,total,3,2,model2,freq,0.1,2);
                [Z3,Zcluster3,results3] = NNUtils.generateTestingData(@R4C3Model,total,3,3,model3,freq,0.1,2);
            end
            Z(:,1) = Z1;
            Z(:,2) = Z2;
            Z(:,3) = Z3;
            Zcluster = [Zcluster1; Zcluster2; Zcluster3];
            results = [results1 results2 results3];
        end
        function trainedNet = trainNet(layers,Zcluster,results,total,trainAmount)
            
            % DEVO PROVARE A LEVARE LA PARTE REALE
            net = patternnet(layers);
            net.trainParam.min_grad = 1e-15;
            net.trainParam.max_fail = 200;
            trainSet = NNUtils.getTrainSet(Zcluster,3,total,trainAmount);
            targets = NNUtils.getTargets(results,3,total,trainAmount);
            trainedNet = train(net,trainSet(1:96,:),targets);
        end
        function [wrongs,testing] = testNet(trainedNet,Zcluster,total,trainAmount)
            
            testingCurves = NNUtils.getTestingSet(Zcluster,3,total,trainAmount);
            testing = trainedNet(testingCurves(1:96,:));
            classes = vec2ind(testing);
            
            wrongs1 = NNUtils.verifyResults(classes,total,trainAmount,3,1);
            wrongs2 = NNUtils.verifyResults(classes,total,trainAmount,3,2);
            wrongs3 = NNUtils.verifyResults(classes,total,trainAmount,3,3);
            wrongs = [wrongs1; wrongs2; wrongs3];
            %
            %             imported = importdata('curva1.csv');
            %             %
            %             data = imported.data;
            %             freq = data(1:48,2);
            %             realPart = -data(1:48,3);
            %             imagPart = -data(1:48,4);
            
            % figure(1)
            % plot(realPart(:,1),-imagPart(:,1),'r')
            % Zn = normalize(realPart+1i*imagPart);
            
            %
            %
            % ok = 0;
            % for i=1:numel(Z)/2
            %     if res(i)==1
            %         ok=ok+1;
            %     end
            % end
            % disp(['Curve con Fouquet']);
            % disp(['cluster 1: ' num2str(ok) ' cluster 2: ' num2str(numel(Z)/2-ok)]);
            %
            %
            %
            % ok = 0;
            % for i=(1+numel(Z)/2:numel(Z))
            %     if res(i)==1
            %         ok=ok+1;
            %     end
            % end
            % disp(['Curve con NewModel']);
            % disp(['cluster 1: ' num2str(ok) ' cluster 2: ' num2str(numel(Z)/2-ok)]);
            
            
            
        end
    end
    
end