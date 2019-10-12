clear all
close all
clc

cd(fileparts(which(mfilename)));
addpath(genpath('.'));

%% Misure Eifer
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

%% 
load('40A_c00.mat');
FrequencyHz = FrequencyHz(1:end);
realPartOfImpedance = realPartOfImpedance(1:end);
imagPartOfImpedance = imagPartOfImpedance(1:end);
    
tem = [-(realPartOfImpedance)-1i*(imagPartOfImpedance), FrequencyHz ];
environment = [tem(:,1) tem(:,2)];

MinRanges = [ 0     0    0   0    0    0]; 
MaxRanges = [0.1   0.5   1   1   0.5   4]; 

options = optimoptions(@ga,'PopulationSize',400,'MaxTime',180,'MaxGenerations',10000,'CrossoverFraction',0.8,'CrossoverFcn',@crossovertwopoint,'EliteCount',4,'SelectionFcn',@selectiontournament,'FunctionTolerance',10e-9);

%% CLASSICO
global MaxRealPart;
MaxRealPart = max(abs(real(environment(:,1))));
global MaxImagPart;
MaxImagPart = max(abs(imag(environment(:,1))));
VFitnessFunction = @(x) objectiveNormalized(x,environment);
numberOfVariables = 6;
lb = MinRanges; 
ub = MaxRanges;
start = 'start'
stop = zeros(10,1);
for i=1:10
tic;
[x,fval,EXITFLAG,OUTPUT] = ga(VFitnessFunction,numberOfVariables,[],[],[],[],lb,ub,[],options)
stop(i) = toc
end
individuo = [x(1) x(2) x(3) x(4) x(5) x(6)]; 
punti_generati_individuo = FouquetModel(individuo, environment(:,2));
figure(1)
plot(real(environment(:,1)),-imag(environment(:,1)),'o r');
hold on;
plot(real(punti_generati_individuo),-imag(punti_generati_individuo),'+ b');


xlabel 'Re(Z) [\Omega]'
ylabel '-Im(Z) [\Omega]';
legend('Reference points','Best Fit individual');
axis equal;
grid on;

disp(stop); 
rmse = sqrt(fval/size(environment,1))