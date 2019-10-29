clc
close all
clearvars
addpath(genpath('.'));
curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
chosenImages = dataset.classifiedImages;
name_model = 'Fouquet';
[model,lb,ub] = set_model_and_bound(name_model);

results = struct('name',[],'params',[],'geneticParams',[],'finalStartParams',[],'fobj',[],'fobjGenetic',[],'Z',[],'freq',[],'count',[],'confidenceIntervals',[]);

for i=1:length(chosenImages)
    fprintf('Fitting curva numero %d\n\n',i);
    battery = chosenImages(i);
    freq = battery.data.FrequencyHz;
    rPart = battery.data.realPartOfImpedance;
    iPart = battery.data.imagPartOfImpedance;
    
    
    [fitter, counter, geneticParams] = GeneticAndTrust(rPart+1j*iPart,freq,'',model,lb,ub);
    
    
    results(i).name = battery.name;
    results(i).params = fitter.Params;
    results(i).fobj = fitter.Resnorm;
    results(i).fobjGenetic = fitnessFunctionNormalizzata(model,geneticParams, [rPart+1j*iPart , freq]);
    results(i).finalStartParams = fitter.StartParams;
    results(i).Z = rPart+1j*iPart;
    results(i).freq = freq;
    results(i).count = counter;
    results(i).geneticParams = geneticParams;
    results(i).confidenceIntervals = fitter.ConfidenceIntervals;
    fprintf('\n');
    
end
%%
printInfo(results);

function printInfo(results)
avg = averageExecutions(results)
oneExe = directExecutions(results)
variation = calculateVariation(results);
% f = counterGraph(results)
end

% esecuzioni medie
function avg = averageExecutions(results)
avg = sum([results.count])/length(results);
end

% esecuzioni dirette (subito trova)
function oneExe = directExecutions(results)
oneExe = length(find([results.count] == 1));
end

% variazione parametri iniziali -> parametri finali
function variation = calculateVariation(results)
variation = zeros(length(results),length(results(1).params));

for i=1:length(results)
    fprintf('%d',i);
    variation(i,:) = (results(i).finalStartParams - results(i).geneticParams)./results(i).geneticParams*100;
    for j=1:length(variation(i,:))
        fprintf('\t%d%%',round(variation(i,j)));
    end
    fprintf('\n');
end
end

% grafico con la distribuzione del counter
function f = counterGraph(results)
indexes = find([results.count]);
values = [results.count];
f = figure();
plot(indexes, values,'Marker','.','MarkerSize',12,'Color','black','LineStyle','none');
xlabel('Numero impedenza');
ylabel('Esecuzioni lsqcurvefit');
end

