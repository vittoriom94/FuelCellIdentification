clc
clearvars
close all


cd(fileparts(which(mfilename)));
addpath(genpath('.'));



data = 'test_w4_sept_data.mat';
load(data);
load('noiseData.mat');


% normal %


% STAMPA CONDIZIONI INIZIALI

 saveFiguresForStartingCondition(fullData);

% CALCOLA INTERVALLI DI CONFIDENZA
% confidenceStats = cell(5,1);
% for i=1:size(fullData,1)
%     group = ConfidenceIntervals.getIntervals(fullData{i,3});
%     confidenceStats{i}= group;
% end
% 
% % STAMPA DATI REALI
% graphNames = {'Normal';'Fuel Starvation';'Cathode Starvation';'Anode Starvation';'Air Starvation'};
% for i=1:size(fullData,1)
%    close all;
%    res = fullData{i,3};
%    conf = confidenceStats{i};
%    fprintf('\nCella numero %d\n\n',i);
%    Z=cell(1,2*size(conf,2));
%    params=cell(size(conf,2),1);
%    plotNames = cell(1+size(conf,2),1);
%    plotNames{1,1} = 'Dati sperimentali';
%    
%    Z{1} = -fullData{i,1}.realPartOfImpedance;
%    Z{2} = -fullData{i,1}.imagPartOfImpedance;
%    for j=1:size(conf,2)
%        [index, resid] = conf{1,j}{1,:};
%        dataSize = 48;
%        rmse = sqrt(resid/dataSize);
%        displayForFile(res.params{index},conf{2,j},conf{3,j},resid,rmse);
% %        params{j,1} = res.params{index};
%        imp = FouquetModel(res.params{index},fullData{i,1}.FrequencyHz);
%        Z{2*j+1} = real(imp);
%        Z{2*j+2} = imag(imp);
%        plotNames{j+1,1} = ['Gruppo residuo ' num2str(j)];
%    end
%    f = ShowData.showByZ(graphNames{i},plotNames,Z);
%    saveas(f,['images/confidenceIntervals/' graphNames{i}],'jpg'); 
% %    ShowData.showByParams(@FouquetModel,fullData{i,1}.FrequencyHz,'grafico',plotNames,params);
% end

% GENERA DATI CON RUMORE

% generaRumore(fullData);

% FITTA DATI GENERATI

% estim = [0.03,0.16,0.17,0.70,0.07,0.28];
% lb = [0.0 0.0 0.0 0.0 0.0 0.0];
% ub = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
% curva = noiseData{1,7};
% fitter = ImpedanceCurveFitter();
% fitter.loadData(real(curva),imag(curva),fullData{1,1}.FrequencyHz,'Normal condition');
% fitter.fit(estim,lb,ub,true);
%
% lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
% upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
% amountOfData = 1000;
% data = generateUniformData(lowerBound, upperBound,amountOfData);
% noiseResult = struct('estim',data,'results',[]);
% results = cell(size(noiseData,1),size(noiseData,2));
% for c=1:size(noiseData,1)
%     for n=1:size(noiseData,2)
%         c
%         n
%         realPartOfImpedance = real(noiseData{c,n});
%         imagPartOfImpedance = imag(noiseData{c,n});
%         FrequencyHz = fullData{c,1}.FrequencyHz;
%         result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[]);
%         [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time] = fitMultiple(realPartOfImpedance,imagPartOfImpedance,FrequencyHz,lowerBound,upperBound,data);
%         results{c,n} = result;
%     end
% end
% noiseResult.results = results;
% save('test_w1_oct_noiseResult.mat','noiseResult')
% 

% STAMPA DATI PER I RISULTATI SIMULATI

% load('test_w1_oct_noiseResult.mat');
% for i=1:size(noiseData,1)
%     fprintf('\nCella numero %d\n\n',i);
%     cases = [1,3,6];
%     for k=1:3
%         j = cases(k);
%         resid = noiseResult.results{i,j}.resid(noiseResult.results{i,j}.index);
%         dataSize = 48;
%         rmse = sqrt(resid/dataSize);
%         confidence = confidenceIntervals(noiseResult.results{i,j});
%         displayForFile(noiseResult.results{i,j}.minparams,noiseResult.results{i,j}.conf{noiseResult.results{i,j}.index},confidence{3,1},resid,rmse);
%     end
% end
%%
function generaRumore(fullData)
for i=1:size(fullData,1)
    
    freq =fullData{i,1}.FrequencyHz;
    params = fullData{i,3}.minparams;
    [noiseData{i,2}, noiseData{i,1}] = generateOneWithNoise(params, freq,45,0);
    noiseData{i,3} = generateOneWithNoise(params, freq,38,0);
    noiseData{i,4} = generateOneWithNoise(params, freq,0.1,1);
    noiseData{i,5} = generateOneWithNoise(params, freq,0.15,1);
    noiseData{i,6} = generateOneWithNoise(params, freq,0.1,2);
    noiseData{i,7} = generateOneWithNoise(params, freq,0.12,2);
    % genera 2 awgn
    % 2 rumore
    % 2 rumore scalato
    % salva clean e le altre 6
    save('noiseData','noiseData');
end

end