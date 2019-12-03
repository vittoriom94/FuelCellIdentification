clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));

warning('off','MATLAB:singularMatrix');

curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
chosenImages = dataset.classifiedImages;
trainingImages = dataset.classifiedImages(1:35);

load('datiFinali/resultTrain.mat');
load('datiFinali/dataFitAndClassTrain.mat');
load('datiFinali/result.mat');
load('datiFinali/dataFitAndClass.mat');
%%
modelNames = {'DhirdeSimple','DhirdeL','DhirdeLWARL'};
amount = 2000;
precision = 0.9999;
requiredLaunchesForced = 0;
count = 0;
total = 0;
launches = zeros(length(trainingImages),1);
for i=1:length(trainingImages)
    convergence(i) = ImpedanceGroups.getConvergence(resultTrain(i),modelNames{3},chosenImages(i).data.FrequencyHz)
    requiredLaunchesForced = max([requiredLaunchesForced log(1-precision)/log(1-convergence(i))]);
    launches(i,1) = log(1-precision)/log(1-convergence(i));
    count=count+1;
    total = total+amount*convergence(i);
           
end
requiredLaunchesForcedAverage = log(1-precision)/log(1-total/(count*amount));

indexes = 1:length(launches);
av = mean(launches)

[convergenceAmounts,launchesAlg] =  getConvergenceAmounts(dataFitAndClassTrain);




% ALGORITMO PER IL NUMERO DI LANCI
% 1. calcola media e std su media lanci
% 2. escludi campioni a media+2 (o 3) * std
% 3. ripeti media e std
% 4. imposta il limite a media + std

stdFull = std(launches)
meanFull = mean(launches)
newLaunches = [];
j = 1;
for i=1:length(launches)
   if launches(i) < meanFull+2*stdFull
       newLaunches(j) = launches(i);
       j=j+1;
   end
end
stdCut = std(newLaunches)
meanCut = mean(newLaunches)

f = figure()

% plot(indexes,launches,'Marker','.','MarkerSize',12);
hold on
grid on
% plot(indexes,meanFull*ones(length(launches)),'r');
% plot(indexes,(meanCut+stdCut)*ones(length(launches)),'g');

stdFull = std(launchesAlg)
meanFull = mean(launchesAlg)
newLaunches = cell(3,1)
for k=1:3
    newLaunchesI = [];
    j = 1;
    for i=1:length(launchesAlg(:,k))
       if launchesAlg(i,k) < meanFull(k)+stdFull(k)
           newLaunchesI(j) = launchesAlg(i,k);
           j=j+1;
       end
    end
    newLaunches(k,1) = {newLaunchesI};
    stdCutAlg(k) = std(newLaunchesI)
    meanCutAlg(k) = mean(newLaunchesI)
end



plot(indexes,launchesAlg(:,3),'k','Marker','.','MarkerSize',14,'LineStyle','none');

plot(indexes,meanFull(3)*ones(length(launchesAlg(:,3)),1),'r');
plot(indexes,(meanCutAlg(3)+stdCutAlg(3))*ones(length(launchesAlg(:,3))),'g');
legend('Number of launches','Mean','Mean + Standard Dev');
xlabel('Spectra number')
ylabel('Launches required')
%%
convProb = zeros(length(trainingImages),2);

for i=1:length(trainingImages)
   convProb(i,1) =  1-(1-dataFitAndClassTrain(i).convergences{1})^(meanCutAlg(1)+stdCutAlg(1));
   convProb(i,2) =  1-(1-dataFitAndClassTrain(i).convergences{2})^(meanCutAlg(2)+stdCutAlg(2));
   convProb(i,3) =  1-(1-dataFitAndClassTrain(i).convergences{3})^(meanCutAlg(3)+stdCutAlg(3));
   convProb(i,4) =  1-(1-convergence(i))^(meanCut+stdCut);
end
%%
fitter = Fitter();
dataFitAndClass = fitter.fit(chosenImages,ceil(meanCutAlg+stdCutAlg));
save('datiFinali/dataFitAndClass.mat','dataFitAndClass')
%%
modelNames = {'DhirdeSimple','DhirdeL','DhirdeLWARL'};
result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
amount = ceil(stdCut+meanCut);
[ model, lowerBound, upperBound ] = set_model_and_bound(modelNames{3});
start = generateUniformData(lowerBound, upperBound,amount);
for i=1:length(chosenImages)
    i
    battery = chosenImages(i);
    freq = battery.data.FrequencyHz;
    rPart = battery.data.realPartOfImpedance;
    iPart = battery.data.imagPartOfImpedance;
%     k = dataFitAndClass(i).choice;
    % DEVO Usare sempre il modello più complesso
    
    
    % fitta
    
    [result(i).resid,result(i).conf,result(i).params,result(i).minparams,result(i).index,result(i).outReason,result(i).time,result(i).initialResid] = ...
        fitMultiple(rPart,iPart,...
        freq,lowerBound,upperBound,1,1,start,model);

end
save('datiFinali/result.mat','result')
%%
launchesAlg1 = ceil(meanCutAlg+stdCutAlg);
amount = ceil(stdCut+meanCut)
comparison = struct('model',[],'minTime',[],'maxTime',[],'avgTime',[],'totTime',[],'reqTrials',[],'rmseNorm',[]);
for i=1:length(chosenImages)

    m = dataFitAndClass(i).choice;

    
    convergence = ImpedanceGroups.getConvergence(result(i),modelNames{3},chosenImages(i).data.FrequencyHz);
        
    comparison(i).model = m;
    comparison(i).minTime = [dataFitAndClass(i).times(3,1) min(cell2mat(result(i).time))];
    comparison(i).maxTime = [dataFitAndClass(i).times(3,2) max(cell2mat(result(i).time))];
    comparison(i).avgTime = [dataFitAndClass(i).times(3,3) mean(cell2mat(result(i).time))];
    totTime = 0;
    for k=1:m
        totTime = totTime + launchesAlg1(k)*dataFitAndClass(i).times{k,3};
    end
    comparison(i).totTime = [totTime amount*mean(cell2mat(result(i).time)) requiredLaunchesForced*mean(cell2mat(result(i).time))];
    comparison(i).reqTrials = [convergenceAmounts(m) log(1-precision)/log(1-convergence)];
    modelForced = set_model_and_bound(modelNames{3});
    modelAlg = set_model_and_bound(modelNames{m});
    rmseSu10000 = RMSEED(chosenImages(i).data.realPartOfImpedance, chosenImages(i).data.imagPartOfImpedance, real(modelForced(result(i).minparams,chosenImages(i).data.FrequencyHz)), imag(modelForced(result(i).minparams,chosenImages(i).data.FrequencyHz)));
    rmseAlgoritmo = RMSEED(chosenImages(i).data.realPartOfImpedance, chosenImages(i).data.imagPartOfImpedance, real(modelAlg(dataFitAndClass(i).params{m},chosenImages(i).data.FrequencyHz)), imag(modelAlg(dataFitAndClass(i).params{m},chosenImages(i).data.FrequencyHz)));
    
    comparison(i).rmseNorm = [ rmseAlgoritmo rmseSu10000 ];
end

%%
tt = [0 0];

for i=1:148

    tt(1) = tt(1) + comparison(i).avgTime{1};
    tt(2) = tt(2)+comparison(i).avgTime{2};

end
tt
tt/148

tt = [0 0];
count = 0;
for i=1:148
    if comparison(i).model == 3
        tt(1) = tt(1) + comparison(i).avgTime{1};
        tt(2) = tt(2)+comparison(i).avgTime{2};
        count = count+1;
    end
end
tt
tt/count
%%
c = [0 0; 0 0; 0 0;0 0];
am = [0 0 0];
for i=1:148
    c(4,1) = c(4,1) + comparison(i).totTime(1);
    c(4,2) = c(4,2) + comparison(i).totTime(2);
    m = comparison(i).model;
    c(m,1) = c(m,1)+comparison(i).totTime(1);
    c(m,2) = c(m,2)+comparison(i).totTime(2);
    am(m) = am(m)+1;

end
c
am
c./[am 148]'
%%


for i=1:148
oldP = dataFitAndClass(i).params{1};
newP = dataFitAndClass(i).params{2};
firstVariation = (newP(1:length(oldP))-oldP)./oldP;
oldP = newP;
newP = dataFitAndClass(i).params{3};
secondVariation = (newP(1:length(oldP))-oldP)./oldP;
dataFitAndClass(i).variations(2,1) = {firstVariation};
dataFitAndClass(i).variations(3,1) = {secondVariation};
end


function [convergenceAmounts, launchesAlg] = getConvergenceAmounts(dataFitAndClass)
amount = 2000;
precision = 0.9999;

for i=1:3
    count = 0;
    total = 0;
    for j=1:length(dataFitAndClass)

            count=count+1;
            total = total+amount*dataFitAndClass(j).convergences{i};
            launchesAlg(j,i) = log(1-precision)/log(1-dataFitAndClass(j).convergences{i});

        
    end
    convergenceAmounts(i,1) = log(1-precision)/log(1-total/(count*amount));
end


end



