clc
clearvars
close all


cd(fileparts(which(mfilename)));
addpath(genpath('.'));



data = 'test_w4_sept_data.mat';
load(data);
load('datiSalvatore.mat');
% classica, v1, v2 (con zeri), normalizzata, sperimentale
%
% datiSalvatore = cell(5,5);
% 
% % itera su -9
% files = dir('Risultati');
% for c=1:5
%     folderName = files(c+2).name;
%     fittings = dir([ 'Risultati/' folderName]);
%     for f=1:5
%         disp(fittings(f+2).name);
%         data = load([fittings(f+2).folder '/' fittings(f+2).name]);
%         [val,minIndex] = min([data.info.fobj]);
%         params = data.info(minIndex).bestInd;
%         datiSalvatore(c,f) = {params};
%     end
% end
% 
% save('datiSalvatore','datiSalvatore');
% 

