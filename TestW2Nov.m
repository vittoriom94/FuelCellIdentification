clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));


load('data/fittingSet20.mat');
% [ model, lb, ub ] = set_model_and_bound('DhirdeCL');
% param1 = {1,'p1',lb(1),ub(1)};
% param2 = {2,'p2',lb(2),ub(2)};
% param3 = {3,'p3',lb(3),ub(3)};
% param4 = {4,'p4',lb(4),ub(4)};
% param5 = {5,'p5',lb(5),ub(5)};
% param6 = {6,'p6',lb(6),ub(6)};
% param7 = {7,'p7',lb(7),ub(7)};
% param8 = {8,'p8',lb(8),ub(8)};
% param9 = {9,'p9',lb(9),ub(9)};
% param10 = {10,'p10',lb(10),ub(10)};
% 
% rp = fittingSet(8).data.realPartOfImpedance;
% ip = fittingSet(8).data.imagPartOfImpedance;
% freq = fittingSet(8).data.FrequencyHz;
% params = fittingSet(8).params{3};
% manipulate({@(x,param) DhirdeCL(param,x),freq,params},{[0.025,0.25],[-0.01,0.05]},rp,ip,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10)
% 

for i=1:length(fittingSet)
   Z = fittingSet(i).data.realPartOfImpedance +1j*fittingSet(i).data.imagPartOfImpedance;
   freq = fittingSet(i).data.FrequencyHz;
   params = fittingSet(i).params;
   models = fittingSet(i).models;
   name = fittingSet(i).name;
   f = ShowData.showPage(Z,params,models,freq,name,[]);
   close(f);
    
end