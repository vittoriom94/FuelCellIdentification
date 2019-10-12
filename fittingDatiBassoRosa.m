function [total_results,total_conf] = fittingDatiBassoRosa
% Misure Eifer
%load('40A_c00.mat');
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/normal');
%load('15A_c00fuelstarv.mat');
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/fuelStarv');
%load('25A_c00cathodeStarv.mat');
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/cathodeStarv');
%load('40A_c00(prima).mat');
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/anodeStarv');
%load('15A_c00AirStarv(ultimacart).mat');
addpath('../consegnaBassoRosa/GeneticoPulito/misureEifer/eifer/airStarv');

estim1 = [0.05 ; 0.25 ; 0.5 ; 0.5 ; 0.25 ; 2.0];
% estim1 = [3e-06;0.1;0.77;0.6;0.2;0.60;0.7;1;0.18];
estim2 = [0.1;0.05;0.05;0.9;0.05;0.3];
estim3 = [0.01;0.1;0.8;0.1;0.4;1.0];
estim4 = [0.01 ; 0.01 ; 0.01 ; 0.01 ; 0.01 ; 0.01];
total_start = [estim1];
total_conf = cell(5,4);
total_results = cell(5,4);
lb = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
ub = [0.2 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];

% lb = [0.0;0.0;0.0;0.5;0.0;0.0;0.0;0.0;0.0];
% ub = [8e-06;0.8;1.0;3.0;1.0;3.0;1;1.0;1.0];

% load('40A_c00.mat');
% fitter = ImpedanceCurveFitter();
% fitter.loadData(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,'Normal condition',false,false);
% for i=1:4
%    fitter.fit(total_start(:,i),lb,ub,false);
%    total_results{1,i} = fitter.Params;
%    total_conf{1,i} = fitter.ConfidenceIntervals;
% end
% 
load('15A_c00fuelstarv.mat');
fitter = ImpedanceCurveFitter();
fitter.loadData(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,'Fuel starvation',false,false);
for i=1:4
   fitter.fit(total_start(:,i),lb,ub,true);
   total_results{2,i} = fitter.Params;
   total_conf{2,i} = fitter.ConfidenceIntervals;
end
% 
% load('25A_c00cathodeStarv.mat');
% fitter = ImpedanceCurveFitter();
% fitter.loadData(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,'Cathode starvation',false,false);
% for i=1:4
%    fitter.fit(total_start(:,i),lb,ub,false);
%    total_results{3,i} = fitter.Params;
%    total_conf{3,i} = fitter.ConfidenceIntervals;
% end
% 
% load('40A_c00(prima).mat');
% fitter = ImpedanceCurveFitter();
% fitter.loadData(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,'Anode starvation',false,false);
% for i=1:4
%    fitter.fit(total_start(:,i),lb,ub,false);
%    total_results{4,i} = fitter.Params;
%    total_conf{4,i} = fitter.ConfidenceIntervals;
% end

% load('15A_c00AirStarv(ultimacart).mat');
% FrequencyHz = FrequencyHz(2:end);
% realPartOfImpedance = realPartOfImpedance(2:end);
% imagPartOfImpedance = imagPartOfImpedance(2:end);
% fitter = ImpedanceCurveFitter();
% fitter.loadData(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,'Air starvation',false,false);
% for i=1:4
%    fitter.fit(total_start(:,i),lb,ub,true);
%    total_results{5,i} = fitter.Params;
%    total_conf{5,i} = fitter.ConfidenceIntervals;
% end

end



