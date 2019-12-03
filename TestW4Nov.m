clc
clearvars
close all

load('data/datiFC.mat');

FCTipologia = struct('numCurva',[],'tipologia',[],'corrente',[]);
for i=1:length(datiFC)
    name = datiFC(i).name(1:end-4);
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

    ampere = name(end-2:end-1);
    FCTipologia(i).numCurva = i;
    FCTipologia(i).tipologia = cond;
    FCTipologia(i).corrente = str2num(ampere);
end