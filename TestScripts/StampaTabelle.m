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
load('datiFinali/comparison.mat');
%%


% quali tabelle devo stampare?
% tabella variazioni
% variazioniTable(dataFitAndClass)
% tabella dati dataFitAndClass
% dataFitAndClassTable(dataFitAndClass,comparison)
% tabella parametri
% parametersTable(dataFitAndClass)
% tabella comparison
% comparisonTable(comparison,launchesAlg1,amount)
% tabella corrispondza num - nome curva
% nameTable(chosenImages)
% tabella rmse
% rmseTable(comparison,dataFitAndClass, chosenImages, result)
% tabella training convergenza
convergenceTable(dataFitAndClassTrain,resultTrain,launchesAlg1,amount,chosenImages)



function convergenceTable(dataFitAndClassTrain,resultTrain,launchesAlg1,amount,chosenImages)
fprintf('\n training convergence Table\n\n');
nimg = length(dataFitAndClassTrain);
convProb = zeros(length(dataFitAndClassTrain),2);
for i = 1:nimg
   convergence = ImpedanceGroups.getConvergence(resultTrain(i),'DhirdeLWARL',chosenImages(i).data.FrequencyHz);
   convProb(i,1) =  1-(1-dataFitAndClassTrain(i).convergences{1})^launchesAlg1(1);
   convProb(i,2) =  1-(1-dataFitAndClassTrain(i).convergences{2})^launchesAlg1(2);
   convProb(i,3) =  1-(1-dataFitAndClassTrain(i).convergences{3})^launchesAlg1(3);
   convProb(i,4) =  1-(1-convergence)^amount;
   percSign = '%';
   fprintf('%d\t%.4f%s\t%.4f%s\t%.4f%s\t%.4f%s\n',i,100*convProb(i,1),percSign,100*convProb(i,2),percSign,100*convProb(i,3),percSign,100*convProb(i,4),percSign);
end
fprintf('\n\n');
end

function rmseTable(comparison, dataFitAndClass,chosenImages,result)
fprintf('\n RMSE Table\n\n');
nimg = length(dataFitAndClass);
R1tot = 0;
R2tot = 0;
R3tot = 0;
R1alg2tot = 0;
R2alg2tot = 0;
R3alg2tot = 0;
c1 = 0;
c2 = 0;
c3 = 0;
Rtot = 0;
for i = 1:nimg
    d = dataFitAndClass(i);
    c = comparison(i);
    ci = chosenImages(i);
    m = d.choice;
    Zgen = ci.data.realPartOfImpedance+1i*ci.data.imagPartOfImpedance;
    Zalg2 = DhirdeLWARL(result(i).minparams,ci.data.FrequencyHz);
    Ralg2 = RMSEED(real(Zgen),imag(Zgen),real(Zalg2),imag(Zalg2));

    if m == 1
        Z = DhirdeSimple(d.params{1},ci.data.FrequencyHz);
        R = RMSEED(real(Zgen),imag(Zgen),real(Z),imag(Z));
        R1tot = R1tot+R;
        R1alg2tot = R1alg2tot +Ralg2;
        c1=c1+1;
    elseif m == 2
        Z = DhirdeL(d.params{2},ci.data.FrequencyHz);
        R = RMSEED(real(Zgen),imag(Zgen),real(Z),imag(Z));
        R2tot = R2tot+R;
        R2alg2tot = R2alg2tot +Ralg2;
        c2=c2+1;
    else
        Z = DhirdeLWARL(d.params{3},ci.data.FrequencyHz);
        R = RMSEED(real(Zgen),imag(Zgen),real(Z),imag(Z));
        R3tot = R3tot+R;
        R3alg2tot = R3alg2tot +Ralg2;
        c3=c3+1;
    end
    fprintf('%d\t%d\t%.4f\t%.4f\n',i,m,R,Ralg2);
    Rtot = Rtot+R;

end
fprintf('\n\n');
fprintf('%.4f\t%.4f\n',R1tot/c1,R1alg2tot/c1);
fprintf('%.4f\t%.4f\n',R2tot/c2,R2alg2tot/c2);
fprintf('%.4f\t%.4f\n',R3tot/c3,R3alg2tot/c3);
fprintf('%.4f\t%.4f\n',Rtot/148,(R1alg2tot+R2alg2tot+R3alg2tot)/148);
fprintf('\n\n');
end

function variazioniTable(dataFitAndClass)

end

function dataFitAndClassTable(dataFitAndClass,comparison)
% N curva - modello - avg times - errore LF - convergenza
fprintf('\n Dati FandC Table\n\n');
nimg = length(dataFitAndClass);
for i = 1:nimg
    d = dataFitAndClass(i);
    m = d.choice;
    percSign = '%';
    avgTimes = sprintf('%.4f s %.4f s %.4f s',d.times{1,3},d.times{2,3},d.times{3,3});
    errorLF = sprintf('%.4f%s %.4f%s %.4f%s',100*d.errors{1,3},percSign,100*d.errors{2,3},percSign,100*d.errors{3,3},percSign);
    %     convRate = sprintf('%.2f%s %.2f%s %.2f%s',100*d.convergences{1,1},percSign,100*d.convergences{2,1},percSign,100*d.convergences{3,1},percSign);
    
    
    fprintf('%d\t%d\t%s\t%s\n',i,m,avgTimes,errorLF);
end
fprintf('\n\n');
end

function comparisonTable(comparison,launchesAlg1,launchesAlg2)
% N curva - modello - totTime alg1 - totTime alg2 - avg3 alg1 - avg3 alg2 - Rmse 1 - RMSE 2
fprintf('\n Dati Comparison Table\n\n');
nimg = length(comparison);
for i = 1:nimg
    c = comparison(i);
    m = c.model;
    
    fprintf('%d\t%d\t%.4f s\t%.4f s\t%.4f s\t%.4f s\t%.4f\t%.4f\n',i,m,c.totTime(1),c.totTime(2),c.avgTime{1,1},c.avgTime{1,2},c.rmseNorm(1),c.rmseNorm(2));
    
end
fprintf('\n\n');
end

function nameTable(chosenImages)
% N curva - Nome completo senza .jpg - condizioni
fprintf('\n Name Table\n\n');
nimg = length(chosenImages);
for i = 1:nimg
    name = chosenImages(i).name(1:end-4);
    splitter = split(name,'_');
    splitter = split(splitter(4),'-');
    condID = splitter(1);
    if strcmp(condID,'nc') == 1
        cond = 'Normal Condition';
    elseif strcmp(condID,'fs') == 1
        cond = 'Fuel Starvation';
    elseif strcmp(condID,'as') == 1
        cond = 'Air Starvation';
    elseif strcmp(condID,'an') == 1
        cond = 'Anode RH% Sensitivity';
    elseif strcmp(condID,'ca') == 1
        cond = 'Cathode RH% Sensitivity';
    elseif strcmp(condID,'fa') == 1
        cond = 'Flooding Anode';
    elseif strcmp(condID,'fc') == 1
        cond = 'Flooding Cathode';
    else
        cond = '-';
    end
    fprintf('%d\t%s\t%s\n',i,name,cond);
    
end
fprintf('\n\n');
end

function parametersTable(dataFitAndClass)
% N curva - 14 params (trattino se non c'è il parametro
fprintf('\n Parameters Table\n\n');
nimg = length(dataFitAndClass);
for i = 1:nimg
    pn = cell(1,14);
    
    for j=1:14
        p = dataFitAndClass(i).params;
        if j<=8
            
            pn(1,j) = {sprintf('%.4g %.4g %.4g',p{1}(j),p{2}(j),p{3}(j))};
        elseif j<11
            pn(1,j) = {sprintf('   -    %.4g %.4g',p{2}(j),p{3}(j))};
        else
            pn(1,j) = {sprintf('   -       -    %.4g',p{3}(j))};
        end
        
    end
    
    fprintf('%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',i,pn{1},pn{2},pn{3},pn{4},pn{5},pn{6},pn{7},pn{8},pn{9},pn{10},pn{11},pn{12},pn{13},pn{14});
end
fprintf('\n\n');
end