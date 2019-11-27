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
chosenImages = dataset.classifiedImages(8:9);

dataFitAndClass = analizzaAndamento(chosenImages);
% load('data/dataFitAndClass.mat');
%
% for i=1:length(dataFitAndClass)
%    Zspe = chosenImages(i).data.realPartOfImpedance +1j*chosenImages(i).data.imagPartOfImpedance;
%    freq = chosenImages(i).data.FrequencyHz;
%    analizzaRisultato(Zspe,dataFitAndClass(i),freq,i);
%
% end


function analizzaRisultato(Zspe,data,freq,i)

f_ev = [0.1 0.5 1 5 10 100];
indexes = zeros(1,length(f_ev));
for j=1:length(indexes)
    indexes(j) = binarySearchInverted(freq,f_ev(j));
end

f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');
% stampa Zspe

plot(real(Zspe),-imag(Zspe),'- k',...
    'Marker','o','MarkerSize',8,'LineStyle','none');

% genera e stampa i 3 modelli

c = DhirdeSimple(data.params{1},freq);
plot(real(c),-imag(c),'r','Marker','.','MarkerSize',11);

c = DhirdeL(data.params{2},freq);
plot(real(c),-imag(c),'b','Marker','.','MarkerSize',11);

c = DhirdeLWARL(data.params{3},freq);
plot(real(c),-imag(c),'g','Marker','.','MarkerSize',11);
% stampa le frequenze di interesse con la X
for j=1:length(indexes)
    plot(real(Zspe(indexes(j))),-imag(Zspe(indexes(j))),'r','LineStyle','none','Marker','x','MarkerSize',12);
end
% leggenda con l'errore %
n0 = ['Punti sperimentali'];
n1 = ['Dhirde semplificato - E%: ' num2str(data.errors{1,3}*100) '%'];
n2 = ['Dhirde + induttore - E%: ' num2str(data.errors{2,3}*100) '%'];
n3 = ['Dhirde + cappio Warburg - E%: ' num2str(data.errors{3,3}*100) '%'];
legend(n0,n1,n2,n3);
% titolo con numero curva - modello scelto
scelta = {'Dhirde semplificato', 'Dhirde + induttore','Dhirde + cappio Warburg'};
title(['Curva numero: ' num2str(i) ' - Modello scelto: ' scelta{data.choice}]);
% salvare come 001 002 ecc
nsave = sprintf('%.3d',i);
saveas(f,['images/fitAndClassify/' nsave],'png');
% chiudi
close(f);
end



function dataFitAndClass = analizzaAndamento(chosenImages)

% come lo stampo?
% mi evidenzio le frequenze: 1, 5, 0.5, 0.1, 10.
f_ev = [0.1 0.5 1 5 10 100];
dataFitAndClass = struct('models',[],'params',[],'errors',[],'variations',[],'choice',[]);
for i=1:length(chosenImages)
    Z = chosenImages(i).data.realPartOfImpedance +1i*chosenImages(i).data.imagPartOfImpedance;
    freq = chosenImages(i).data.FrequencyHz;
    indexes = zeros(1,length(f_ev));
    for j=1:length(indexes)
        indexes(j) = binarySearchInverted(freq,f_ev(j));
    end
    f = figure();
    hold on
    grid on
    axis equal
    xlabel('Re(Z) [\Omega]');
    ylabel('-Im(Z) [\Omega]');
    plot(real(Z),-imag(Z),'- k',...
        'Marker','.','MarkerSize',14);
    for j=1:length(indexes)
        plot(real(Z(indexes(j))),-imag(Z(indexes(j))),'LineStyle','none','Marker','o','MarkerSize',12);
    end
    
    params = cell(3,1);
    models= cell(3,1);
    errors = cell(3,3);
    variations = cell(3,1);
    choice = 0;
    
    
    
    % fai fitting
    model = 'DhirdeSimple';
    amount = 17;
    [result,Zgen] = fitWithModel(Z,freq,model,amount, []);
    convergence = ImpedanceGroups.getConvergence(result,model,freq)
    % stampa retta
    plot(real(Zgen),-imag(Zgen),'- r',...
        'Marker','.','MarkerSize',14);
    % calcola errore a bassa frequenza
    directionsLow = zeros(length(Zgen)-1-indexes(3),1);
    distancesLow = directionsLow;
    xerrorLow = directionsLow;
    yerrorLow = directionsLow;
    totalerrorLow = directionsLow;
    for j=indexes(3):length(Zgen)-1
        ind = j+1-indexes(3);
        [directionsLow(ind), distancesLow(ind), xerrorLow(ind), yerrorLow(ind), totalerrorLow(ind)] = checkDirectionAndDistance(Z,Zgen,j);
    end
    % calcola errore ad alta frequenza
    directionsHigh = zeros(indexes(6),1);
    distancesHigh = directionsHigh;
    xerrorHigh = directionsHigh;
    yerrorHigh = directionsHigh;
    totalerrorHigh = directionsHigh;
    for j=1:indexes(6)
        ind = j;
        [directionsHigh(ind), distancesHigh(ind), xerrorHigh(ind), yerrorHigh(ind), totalerrorHigh(ind)] = checkDirectionAndDistance(Z,Zgen,j);
    end
    
    % mi trovo l'equazione y = ax+b, ho il punto x0,y0, se y0 > ax0 +b allora il punto è sopra
    % non va bene con la retta
    fprintf('\nDHIRDE SEMPLICE: xerror medio: %.4f, yerror medio: %.4f, total error medio: %.4f\n', mean(xerrorLow),mean(yerrorLow),mean(totalerrorLow));
    fprintf('Errore alta freq: xerror medio: %.4f, yerror medio: %.4f, total error medio: %.4f\n', mean(xerrorHigh),mean(yerrorHigh),mean(totalerrorHigh));
    oldParams = result.minparams;
    if mean(totalerrorLow) < 0.01 || length(unique(directionsLow)) == 1
        fprintf('Concluso\n');
        choice = 1;
    end
    params{1,1} = result.minparams
    models{1,1} = model;
    errors{1,1} = mean(xerrorLow);
    errors{1,2} = mean(yerrorLow);
    errors{1,3} = mean(totalerrorLow);
    variations{1,1} = 0;
    
    model = 'DhirdeL';
    amount = 24;
    [result,Zgen] = fitWithModel(Z,freq,model,amount, oldParams,[1 2 3 4 8]);
    convergence = ImpedanceGroups.getConvergence(result,model,freq)
    % stampa retta
    plot(real(Zgen),-imag(Zgen),'- r',...
        'Marker','.','MarkerSize',14);
    directionsLow = zeros(length(Zgen)-1-indexes(3),1);
    distancesLow = directionsLow;
    xerrorLow = directionsLow;
    yerrorLow = directionsLow;
    totalerrorLow = directionsLow;
    for j=indexes(3):length(Zgen)-1
        ind = j+1-indexes(3);
        [directionsLow(ind), distancesLow(ind), xerrorLow(ind), yerrorLow(ind), totalerrorLow(ind)] = checkDirectionAndDistance(Z,Zgen,j);
    end
    % mi trovo l'equazione y = ax+b, ho il punto x0,y0, se y0 > ax0 +b allora il punto è sopra
    % non va bene con la retta
    fprintf('\nDHIRDE L: xerror medio: %.4f, yerror medio: %.4f, total error medio: %.4f\n', mean(xerrorLow),mean(yerrorLow),mean(totalerrorLow));
    
    
    firstVariation = checkVariation(oldParams,result.minparams);
    oldParams = result.minparams;
    if mean(totalerrorLow) < 0.01 || length(unique(directionsLow)) == 1
        fprintf('Concluso\n');
        if choice == 0
            choice = 2;
        end
    end
    params{2,1} = result.minparams
    models{2,2} = model;
    errors{2,1} = mean(xerrorLow);
    errors{2,2} = mean(yerrorLow);
    errors{2,3} = mean(totalerrorLow);
    variations{2,1} = firstVariation;
    
    
    
    model = 'DhirdeLWARL';
    amount = 42;
    [result,Zgen] = fitWithModel(Z,freq,model,amount,result.minparams,[1 2 3 4 8 9 10 11]);
    convergence = ImpedanceGroups.getConvergence(result,model,freq)
    % stampa retta
    plot(real(Zgen),-imag(Zgen),'- r',...
        'Marker','.','MarkerSize',14);
    directionsLow = zeros(length(Zgen)-1-indexes(3),1);
    distancesLow = directionsLow;
    xerrorLow = directionsLow;
    yerrorLow = directionsLow;
    totalerrorLow = directionsLow;
    for j=indexes(3):length(Zgen)-1
        ind = j+1-indexes(3);
        [directionsLow(ind), distancesLow(ind), xerrorLow(ind), yerrorLow(ind), totalerrorLow(ind)] = checkDirectionAndDistance(Z,Zgen,j);
    end
    % mi trovo l'equazione y = ax+b, ho il punto x0,y0, se y0 > ax0 +b allora il punto è sopra
    % non va bene con la retta
    fprintf('\nDHIRDE L WAR L xerror medio: %.4f, yerror medio: %.4f, total error medio: %.4f\n', mean(xerrorLow),mean(yerrorLow),mean(totalerrorLow));
    %     result.minparams
    secondVariation = checkVariation(oldParams,result.minparams);
    if choice == 0
        choice = 3;
    end
    params{3,1} = result.minparams
    models{3,1} = model;
    errors{3,1} = mean(xerrorLow);
    errors{3,2} = mean(yerrorLow);
    errors{3,3} = mean(totalerrorLow);
    variations{3,1} = secondVariation;
    
    dataFitAndClass(i).models = models;
    dataFitAndClass(i).params = params;
    dataFitAndClass(i).variations = variations;
    dataFitAndClass(i).choice = choice;
    dataFitAndClass(i).errors = errors;
    
    close(f);
end

end

function variation = checkVariation(oldP,newP)
variation = (newP(1:length(oldP))-oldP)./oldP;
end


function [direction,distance,xerror,yerror,totalerror] = checkDirectionAndDistance(Z,Zgen,index)

maxDist = max(abs(Zgen));

x1 =  real(Zgen(index));
y1 =  -imag(Zgen(index));

x2 = real(Zgen(index+1));
y2 =  -imag(Zgen(index+1));
plot([x1 x2],[y1 y2],'g','Marker','x','MarkerSize',12);

m = (y2-y1)/(x2-x1);
q = y2-(y2-y1)*x2/(x2-x1);

ymisurata = -imag(Z(index));
ymassima = m*real(Z(index)) + q;

direction = not(xor(ymisurata > ymassima, m < 0));

distance = abs(ymisurata - (m*real(Z(index)) + q))/sqrt(1+m^2);

xerror = abs((x1-real(Z(index)))/real(Z(index)));
yerror = abs((y1-ymisurata)/ymisurata);

distmis = sqrt(real(Z(index))^2 + imag(Z(index))^2);
distgen = sqrt(real(Zgen(index))^2 + imag(Zgen(index))^2);
totalerror = abs(distmis-distgen)/maxDist;

end

function [result,Zgen] = fitWithModel(Z,freq,model,amount,previousParams,fixed)



[ model, lowerBound, upperBound ] = set_model_and_bound(model);
start = generateUniformData(lowerBound, upperBound,amount) ;
if(~isempty(previousParams))
    for i=1:length(fixed)
        index = fixed(i);
        start(:,index) = previousParams(index);
        %         start(:,1:length(previousParams)) = repmat(previousParams,size(start,1),1);
    end
end
result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
    fitMultiple(real(Z),imag(Z),...
    freq,lowerBound,upperBound,1,1,start,model);
Zgen = model(result.minparams,freq);

end