clc
clearvars
close all

if(~isdeployed)
    cd(fileparts(which(mfilename)));
end
addpath(genpath('.'));
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/normal');
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/airStarv');
load('15A_c00AirStarv(ultimacart).mat');
% p = [0.06754 0.12344 0.09281 0.7254 0.07832 0.342];
% init_p = [0.05  0.1 0.08 0.6 0.09 0.3];

FrequencyHz = FrequencyHz(2:end);
realPartOfImpedance = realPartOfImpedance(2:end);
imagPartOfImpedance = imagPartOfImpedance(2:end);
[resid,conf,params,minparams] = fitMultiple(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,10000);

%%
lb = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
ub = [0.2 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
param1 = {1,'Romega',lb(1),ub(1)};
param2 = {2,'Rct',lb(2),ub(2)};
param3 = {3,'Q',lb(3),ub(3)};
param4 = {4,'phi',lb(4),ub(4)};
param5 = {5,'Rd',lb(5),ub(5)};
param6 = {6,'tauD',lb(6),ub(6)};

manipulate({@(x,param) FouquetModel(param,x),FrequencyHz,minparams},{[0.025,0.25],[-0.01,0.05]},-realPartOfImpedance,-imagPartOfImpedance,param1,param2,param3,param4,param5,param6)
