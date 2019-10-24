clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));

% load('simuDataNN.mat');

% voglio usare lo stesso dataset di 30000 curve
% [Z,Zcluster,results] = Classification.generateData(total,trainAmount,false);

%% caso 1: 500 curve generate
% 1.1 24 nodi
% 1.2 48
% 1.3 96
% 1.4 24 12
% 1.5 48 24
% 1.6 96 48
% 
c = load('data\classifier.mat');
dataset = DataSet('../ImportData',c.classifier);
images = dataset.classifiedImages;
dim = length(images);

for i=1:dim

   
   Z{i,1} = NNUtils.normalize(images(i).data.realPartOfImpedance+1i*images(i).data.imagPartOfImpedance);
   Zcluster(i,:) = [real(cell2mat(Z(i,1))') imag(cell2mat(Z(i,1))')];
   res = zeros(3,1);
   res(images(i).class,1) = 1;
   results(:,i)=res;
    
    
end
total = [ 0 0 140 157];
trainAmount = [ 0 40 57];
% base = 100;
% [Z,Zcluster] = NNUtils.augment(Z,Zcluster, total, trainAmount, base);
mult = 5;
[Z,Zcluster,results,total,trainAmount] = NNUtils.augmentExisting(Z,Zcluster,results, total, trainAmount, mult);
layers = {24,48,96,[24 12],[48 24],[96 48], [96 48 24]};
linesName = {'Rete 24','Rete 48','Rete 96','Rete 24 - 12','Rete 48 - 24','Rete 96 - 48','Rete 96 - 48 -24'};
disp('TEST');
allWrongs = {};
for i=1:length(layers)
    fprintf('Testing layer %d\n',i);
    for j=1:10
        fprintf('Attempt number %d\n',j);
        
        trainedNet = Classification.trainNet(layers{i},Zcluster,results,total,trainAmount);
        [newWrongs, testing] = Classification.testNet(trainedNet,Zcluster,total,trainAmount);
        allWrongs(i,j) = {newWrongs};

        
    end
%     fprintf('Best j is %d with size %d\n',bestJ,size(wrongs,1));
    %     f = displayWrongs(wrongs,Z);
    %     savePath = ['images/classification/test1_' replace(num2str(layers{i}),' ','_')];
    %     saveas(f,savePath,'jpg');
    %     close(f);
end
name = 'Curve errate (normalizzate)';

% f = displayAllWrongs(allWrongs,Z,name,linesName);
% [Zaug1, ZclusterAug1] = augment(Z(:,1),Zcluster(:,1:total),base);
% [Zaug2, ZclusterAug2] = augment(Z(:,2),Zcluster(:,1:total),base);
% [Zaug3, ZclusterAug3] = augment(Z(:,3),Zcluster(:,1:total),base);
% Zaug(:,1) = Zaug1;
% Zaug(:,2) = Zaug2;
% Zaug(:,3) = Zaug3;
% ZclusterAug = [ZclusterAug1; ZclusterAug2; ZclusterAug3];


function f = displayAllWrongs(allWrongs,Z,graphName,linesName)
f = figure;
hold on
grid on
xlabel('Re(Z)');
ylabel('-Im(Z)');
title(graphName);
co = get(gca,'colororder'); % dimensione = 7
plotObjects = [];
for i=1:size(allWrongs,1)
    wrongs = allWrongs{i,1};
    for j=1:size(wrongs,1)
        imp = Z{wrongs(j,1),wrongs(j,2)};
        p = plot(real(imp),-imag(imp),'Color',co(i,:),'Marker','.','MarkerSize',8);
        if i==1
            plotObjects(end+1) = p;
        end
    end
end
legend(plotObjects,linesName);
end

function f = displayWrongs(wrongs,Z)

f = figure;
hold on

for i=1:size(wrongs,1)
    imp = Z{wrongs(i,1),wrongs(i,2)};
    plot(real(imp),-imag(imp),'k','Marker','.','MarkerSize',8);
    
    
end
end

function [Z, Zcluster] = augment(Z,Zcluster,trainAmount, base)

for j=1:base
    Zbase = Z{1+(j-1)*trainAmount/base,1};
    Zaug = generateFromImpedance(Zbase,trainAmount/base);
    for k=1:size(Zaug,1)
        Z{(j-1)*size(Zaug,1)+k,1} = NNUtils.normalize(Zaug{k,1});
        Zcluster((j-1)*size(Zaug,1)+k,:) = [real(cell2mat(Z((j-1)*size(Zaug,1)+k,1))') imag(cell2mat(Z((j-1)*size(Zaug,1)+k,1))')];
    end
    
end

end