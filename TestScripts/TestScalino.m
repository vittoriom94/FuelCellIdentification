clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));

% model = 'FouquetRC';
amount = 2000;

% [ model, lowerBound, upperBound ] = set_model_and_bound(model);
% start = generateUniformData(lowerBound, upperBound,amount);
curva = '../ImportData\Air Starvation\170412_1035_DT46_AS-P2_EIS-40Aprocessed/c00.mat';
load(curva);

rPart = realPartOfImpedance;
iPart = imagPartOfImpedance;
freq = FrequencyHz;


% fitta
% result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
% [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
%     fitMultiple(rPart,iPart,...
%     freq,lowerBound,upperBound,1,1,start,model);


% newZ = model(result.minparams,freq);
figure();

grid on
axis equal
% plot(rPart,-iPart,'Marker','.','MarkerSize',10);
% plot(real(newZ),-imag(newZ),'Marker','.','MarkerSize',10);


%fitto quella curva con diversi modelli: FouquetRC e Dhirde

%fouquet RC
[ model, lowerBound, upperBound ] = set_model_and_bound('FouquetRC');
start = generateUniformData(lowerBound, upperBound,amount);

result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
    fitMultiple(rPart,iPart,...
    freq,lowerBound,upperBound,1,1,start,model);

subplot(1,2,1);
title('Fouquet+RC');
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

hold on
newZ = model(result.minparams,freq);
plot(rPart,-iPart,'Marker','.','MarkerSize',10);
plot(real(newZ),-imag(newZ),'Marker','.','MarkerSize',10);
[ model, lowerBound, upperBound ] = set_model_and_bound('FouquetRC');
result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
    fitMultiple(rPart(10:35),iPart(10:35),...
    freq(10:35),lowerBound,upperBound,1,1,start,model);

newZ = model(result.minparams,freq);
plot(real(newZ),-imag(newZ),'Marker','.','MarkerSize',10);
legend('Curva sperimentale','Tutti i punti','10-35');

%Dhirde
[ model, lowerBound, upperBound ] = set_model_and_bound('Dhirde');
start = generateUniformData(lowerBound, upperBound,amount);

result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
    fitMultiple(rPart,iPart,...
    freq,lowerBound,upperBound,1,1,start,model);

subplot(1,2,2);
title('Dhirde');
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

hold on
newZ = model(result.minparams,freq);
plot(rPart,-iPart,'Marker','.','MarkerSize',10);
plot(real(newZ),-imag(newZ),'Marker','.','MarkerSize',10);

[ model, lowerBound, upperBound ] = set_model_and_bound('Dhirde');
result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
    fitMultiple(rPart(10:35),iPart(10:35),...
    freq(10:35),lowerBound,upperBound,1,1,start,model);

newZ = model(result.minparams,freq);
plot(real(newZ),-imag(newZ),'Marker','.','MarkerSize',10);
legend('Curva sperimentale','Tutti i punti','10-35');