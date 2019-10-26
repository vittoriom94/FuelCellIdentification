clear all
close all
clc

folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Quando si usano i file dalla cartella misureEifer bisogna invertire il
% segno della parte reale e la parte immaginaria dell'impedenza
load('curve.mat')

% MODELLI A DISPOSIZIONE: 
% Fouquet
% FouquetRC
% FouquetRCPE
% FouquetRWar
% CompleteAnodeCathode
% SimplifiedAnodeCathode
% Dhirde
% DhirdeC
% Asghari
% AsghariWar
% R4C3
% LLFin
% LLFout
name_model = 'Fouquet';
[model,lb,ub] = set_model_and_bound(name_model);

FrequencyHz = chosenImages(12).data.FrequencyHz;
realPartOfImpedance = chosenImages(12).data.realPartOfImpedance;
imagPartOfImpedance = chosenImages(12).data.imagPartOfImpedance;

f = figure();
plot(realPartOfImpedance(:,1),-imagPartOfImpedance(:,1),'k','Marker','.','MarkerSize',16,'LineWidth',2);
axis equal;
grid on;
hold on;

Z = realPartOfImpedance+1i*imagPartOfImpedance;

fitter = GeneticAndTrust(Z(1:48),FrequencyHz(1:48),'',model,lb,ub);

gen = model(fitter.Params,FrequencyHz);
plot(real(gen),-imag(gen),'r','Marker','.','MarkerSize',16,'LineWidth',2);
