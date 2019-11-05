clc
clearvars
close all

if(~isdeployed)
    cd(fileparts(which(mfilename)));
end

addpath(genpath('.'));
data = 'test_w4_sept_data.mat';
load(data);

%%
params = [0.5 0.5 0.005];
FrequencyHz = fullData{1,1}.FrequencyHz;
curva = RRCModel(params,FrequencyHz);
realPartOfImpedance = -real(curva);
imagPartOfImpedance = -imag(curva);
% lb = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
% ub = [0.2 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
            lb = [0.0 0.2 0.001];
            ub = [0.5 0.5 0.05];
param1 = {1,'Romega',lb(1),ub(1)};
param2 = {2,'Rct',lb(2),ub(2)};
param3 = {3,'Q',lb(3),ub(3)};
% param4 = {4,'phi',lb(4),ub(4)};
% param5 = {5,'Rd',lb(5),ub(5)};
% param6 = {6,'tauD',lb(6),ub(6)};

manipulate({@(x,param) RRCModel(param,x),FrequencyHz,params},{[0.025,0.25],[-0.01,0.05]},-realPartOfImpedance,-imagPartOfImpedance,param1,param2,param3)
