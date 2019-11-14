clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));


load('data/fittingSet20.mat');
% [ model, lb, ub ] = set_model_and_bound('DhirdeCL');
% param1 = {1,'p1',lb(1),ub(1)};
% param2 = {2,'p2',lb(2),ub(2)};
% param3 = {3,'p3',lb(3),ub(3)};
% param4 = {4,'p4',lb(4),ub(4)};
% param5 = {5,'p5',lb(5),ub(5)};
% param6 = {6,'p6',lb(6),ub(6)};
% param7 = {7,'p7',lb(7),ub(7)};
% param8 = {8,'p8',lb(8),ub(8)};
% param9 = {9,'p9',lb(9),ub(9)};
% param10 = {10,'p10',lb(10),ub(10)};
%
% rp = fittingSet(8).data.realPartOfImpedance;
% ip = fittingSet(8).data.imagPartOfImpedance;
% freq = fittingSet(8).data.FrequencyHz;
% params = fittingSet(8).params{3};
% manipulate({@(x,param) DhirdeCL(param,x),freq,params},{[0.025,0.25],[-0.01,0.05]},rp,ip,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10)
%
%
% for i=1:length(fittingSet)
%    Z = fittingSet(i).data.realPartOfImpedance +1j*fittingSet(i).data.imagPartOfImpedance;
%    freq = fittingSet(i).data.FrequencyHz;
%    params = fittingSet(i).params;
%    models = fittingSet(i).models;
%    name = fittingSet(i).name;
%    f = ShowData.showPage(Z,params,models,freq,name,[]);
%    saveas(f,['images/Prime20Freq/fitt_' fittingSet(i).name]);
%    close(f);
%
% end
%
%
% for c=1:length(fittingSet)
%     Z = cell(2+length(fittingSet(c).models)*2,1);
%     freqs = cell(1+length(fittingSet(c).models),1);
%     names = cell(1+length(fittingSet(c).models),1);
%
%     freqs(1) = {fittingSet(c).data.FrequencyHz};
%     Z(1) = {fittingSet(c).data.realPartOfImpedance};
%     Z(2) = {fittingSet(c).data.imagPartOfImpedance};
%     names(1) = {'Sperimentale'};
%     for i=1:length(fittingSet(c).models)
%         names(1+i) = fittingSet(c).models(i);
%
%         % devo generare la curva
%         model = set_model_and_bound(fittingSet(c).models{i});
%         curva = model(fittingSet(c).params{i},fittingSet(c).data.FrequencyHz);
%         freqs(1+i) = {fittingSet(c).data.FrequencyHz};
%         Z(2+2*i-1) = {real(curva)};
%         Z(2+2*i) = {imag(curva)};
%     end
%     f = ShowData.showByZFrequency(names,Z,freqs);
%     saveas(f,['images/Prime20Freq/freq_' fittingSet(c).name]);
%     close(f)
% end


load('data/infoResidui.mat');

images = dir('images/fitAndClassify/*.png');

for i=1:20
    f = figure();
    set(f,'units','pix','position',[900 100 600 900])
    
    ax = axes(f);
    set(ax,'units','pix','position',[0 300 600 600])
    imageObject = imread([images(i).folder '/' images(i).name]);
    imshow(imageObject,'parent',ax);
    
    fs = sprintf('Numero curva: %d',i);
    
    uicontrol(f,'style','text','Units','pixels','String',fs,...
        'Position',[200 850 200 30],'FontSize',10,...
        'HorizontalAlignment','center');
    
    chosen = 0;
    fs = sprintf('RMSE FouquetL: %.6f',allInfo(i,1));
    if allInfo(i,1) < 0.3
        chosen = 1;
        fs = [fs sprintf('  <-- Modello Scelto')];
    end
    uicontrol(f,'style','text','Units','pixels','String',fs,...
        'Position',[100 300 400 30],'FontSize',10,...
        'HorizontalAlignment','left');
    fs = sprintf('RMSE DhirdeL: %.6f',allInfo(i,2));
    if allInfo(i,2) < 0.3 && chosen == 0
        chosen = 1;
        fs = [fs sprintf('  <-- Modello Scelto')];
    end
    uicontrol(f,'style','text','Units','pixels','String',fs,...
        'Position',[100 270 400 30],'FontSize',10,...
        'HorizontalAlignment','left');
    fs = sprintf('RMSE DhirdeLWARL: %.6f',allInfo(i,3));
    if chosen == 0
        chosen = 1;
        fs = [fs sprintf('  <-- Modello Scelto')];
    end
    uicontrol(f,'style','text','Units','pixels','String',fs,...
        'Position',[100 240 400 30],'FontSize',10,...
        'HorizontalAlignment','left');
    
    saveas(f,['images/fitAndClassify/full_' num2str(i)],'png');
    close(f);
    
end


