clear all
close all
clc

% folder = fileparts(which(mfilename)); 
% addpath(genpath(folder));
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/normal');
                
load('40A_c00.mat');
%load('15A_c00fuelstarv.mat');
%load('25A_c00cathodeStarv.mat');
%load('40A_c00(prima).mat');
%load('15A_c00AirStarv(ultimacart).mat');


% MODELLI A DISPOSIZIONE: 
% Fouquet
% Dhirde
% Asghari
% R4C3
% FouquetRC
name_model = 'Fouquet';
[model,numvar,lb,ub] = set_model_and_bound(name_model);

% Quando si usano i file dalla cartella misureEifer bisogna invertire il
% segno della parte reale e la parte immaginaria dell'impedenza
f = figure();
%plot(realPartOfImpedance(:,1),-imagPartOfImpedance(:,1),'k','Marker','.','MarkerSize',16,'LineWidth',2);
plot(-realPartOfImpedance(:,1),+imagPartOfImpedance(:,1),'k','Marker','.','MarkerSize',16,'LineWidth',2);
axis equal;
grid on;
hold on;
    
% imagPartOfImpedance = checkPoint(imagPartOfImpedance);
%Z = realPartOfImpedance+1i*imagPartOfImpedance;
Z = -realPartOfImpedance-1i*imagPartOfImpedance;

fitter = GeneticAndTrust(Z(1:48),FrequencyHz(1:48),'',model,numvar,lb,ub);

gen = model(fitter.Params,FrequencyHz);
plot(real(gen),-imag(gen),'r','Marker','.','MarkerSize',16,'LineWidth',2);