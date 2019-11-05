clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));


load('data/fittingSetPrime10e12.mat');

% per ogni curva -->

for c=1:length(fittingSet)
    fittingSet(c).models(4) = [];
    fittingSet(c).params(4) = [];
    Z = cell(2+length(fittingSet(c).models)*2,1);
    freqs = cell(1+length(fittingSet(c).models),1);
    names = cell(1+length(fittingSet(c).models),1);
    
    freqs(1) = {fittingSet(c).data.FrequencyHz};
    Z(1) = {fittingSet(c).data.realPartOfImpedance};
    Z(2) = {fittingSet(c).data.imagPartOfImpedance};
    names(1) = {'Sperimentale'};
    for i=1:length(fittingSet(c).models)
        names(1+i) = fittingSet(c).models(i);
        
        % devo generare la curva
        model = set_model_and_bound(fittingSet(c).models{i});
        curva = model(fittingSet(c).params{i},fittingSet(c).data.FrequencyHz);
        freqs(1+i) = {fittingSet(c).data.FrequencyHz};
        Z(2+2*i-1) = {real(curva)};
        Z(2+2*i) = {imag(curva)};
    end
    f = ShowData.showByZFrequency(names,Z,freqs); 
    saveas(f,['images/Prime10Freq/' fittingSet(c).name]);
    close(f)
end
