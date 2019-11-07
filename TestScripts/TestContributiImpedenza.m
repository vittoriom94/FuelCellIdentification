clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));


load('data/fittingSet20.mat');

contributi = cell(length(fittingSet),length(fittingSet(1).models));
for i=1:length(fittingSet)
    Z = fittingSet(i).data.realPartOfImpedance +1j*fittingSet(i).data.imagPartOfImpedance;
    freq = fittingSet(i).data.FrequencyHz;
    params = fittingSet(i).params;
    models = fittingSet(i).models;
    name = fittingSet(i).name;

    for j=1:length(models)
        contributi(i,j) = {Components.getImpedances(models{j},params{j}, freq)};
    end
end

