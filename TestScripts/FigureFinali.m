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

tot = 1;
models = {'DhirdeSimple','DhirdeL','DhirdeLWARL'};
for i=1:tot
    d = chosenImages(i).data;
    Zexp = d.realPartOfImpedance+1j*d.imagPartOfImpedance; 
    params = dataFitAndClass(i).params;
    freq = d.FrequencyHz;
    s = dataFitAndClass(i).choice;
    f = showPage(Zexp,[params; {result(i).minparams}],freq,['Spectra ' num2str(i)],s);
    g = showImage(Zexp,[params; {result(i).minparams}],freq,['Spectra ' num2str(i)],s);
    h = showImageV2(Zexp,[params; {result(i).minparams}],freq,['Spectra ' num2str(i)],s);
    saveas(f,['immaginiFinali/tuttiFit/' sprintf('%.3d_t1',i)],'png');
    saveas(g,['immaginiFinali/tuttiFit/' sprintf('%.3d_t2',i)],'png');
    saveas(h,['immaginiFinali/tuttiFit/' sprintf('%.3d_t3',i)],'png');
    close(f);
    close(g);
    close(h);
end


function f = showImage(Z,params,freq,cellName,s)

models = {'DhirdeSimple','DhirdeL','DhirdeLWARL','DhirdeLWARL'};
legendParams = {'Model 1, MA','Model 2, MA','Model 3, MA','Direct Algorithm'};
legendParams{s} = [legendParams{s} ', S'];
co = [0 0 1;
     1 0 0;
     0 1 0;
     0.8 120/255 0];
 set(groot,'defaultAxesColorOrder',co);
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');
title(replace(cellName,'_','\_'));
markers ={'.','.','.','o'};
sizeMarkers = [ 10 10 10 6];
widths = [ 1 1 1 2];
for i=1:length(params)
    [model,~,~,names] = set_model_and_bound(models{i});
    imp = model(params{i},freq);
    plot(real(imp),-imag(imp),'Marker',markers{i},'MarkerSize',sizeMarkers(i),'lineWidth',widths(i));
end
plot(real(Z),-imag(Z),'k',...
    'Marker','o','MarkerSize',8,'LineStyle','none');
legend([legendParams 'Experimental Data']);
f.CurrentAxes.Children = [f.CurrentAxes.Children(1); f.CurrentAxes.Children(3:5); f.CurrentAxes.Children(2)];



end



function f = showImageV2(Z,params,freq,cellName,s)
models = {'DhirdeSimple','DhirdeL','DhirdeLWARL','DhirdeLWARL'};
legendParams = {'Model 1, MA','Model 2, MA','Model 3, MA','Direct Algorithm'};
legendParams{s} = [legendParams{s} ', S'];
co = [0 0 1;
     1 0 0;
     0 1 0;
     0.8 120/255 0];
 set(groot,'defaultAxesColorOrder',co);
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');
title(replace(cellName,'_','\_'));
markers ={'.','.','.','o'};
sizeMarkers = [ 10 10 10 6];
widths = [ 1 1 1 2];
for i=1:length(params)
    [model,~,~,names] = set_model_and_bound(models{i});
    imp = model(params{i},freq);
    plot(real(imp),-imag(imp),'Marker',markers{i},'MarkerSize',sizeMarkers(i),'lineWidth',widths(i));
    nrmse = RMSEED(real(Z),imag(Z),real(imp),imag(imp));
    
    legendParams{i} = [legendParams{i} sprintf(', %.4f',nrmse)];
end
plot(real(Z),-imag(Z),'k',...
    'Marker','o','MarkerSize',8,'LineStyle','none');
legend([legendParams 'Experimental Data']);
f.CurrentAxes.Children = [f.CurrentAxes.Children(1); f.CurrentAxes.Children(3:5); f.CurrentAxes.Children(2)];

end


function f = showPage(Z,params,freq,cellName,s)
% stampa z sperimentale: no linea solo cerchi
% cicla su params e models per stamparli
models = {'DhirdeSimple','DhirdeL','DhirdeLWARL','DhirdeLWARL'};
legendParams = {'Model 1, MA','Model 2, MA','Model 3, MA','Direct Algorithm'};
legendParams{s} = [legendParams{s} ', S'];
co = [0 0 1;
     1 0 0;
     0 1 0;
     0.8 120/255 0];
 set(groot,'defaultAxesColorOrder',co);
f = figure();
set(f,'units','pix','position',[900 100 600 900])

ax = axes(f);



set(ax,'units','pix','position',[70 410 490 450])
%             title(graphTitle)
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');
title(replace(cellName,'_','\_'));
baseX = 40;
baseY = 40;
lengthX = 125;
lengthY = 320;
spacingY = 10;
spacingX = 10;
markers ={'.','.','.','o'};
sizeMarkers = [ 10 10 10 6];
widths = [ 1 1 1 2];
for i=1:length(params)
    [model,~,~,names] = set_model_and_bound(models{i});
    imp = model(params{i},freq);
    plot(real(imp),-imag(imp),'Marker',markers{i},'MarkerSize',sizeMarkers(i),'lineWidth',widths(i));
    fs = sprintf('%s\n\n',legendParams{i});
    for j=1:length(names)
        fs = [fs names{j} ' = ' sprintf('%.4g;\n',params{i}(j))];
    end
    fs  = [fs sprintf('\nNRMSE = %.4g',RMSEED(real(Z),imag(Z),real(imp),imag(imp)))];
    uicontrol(f,'style','text','Units','pixels','String',fs,...
        'Position',[baseX baseY lengthX lengthY],'FontSize',10,...
        'HorizontalAlignment','left');
    baseX = baseX + lengthX + spacingX;
    
end
plot(ax,real(Z),-imag(Z),'k',...
    'Marker','o','MarkerSize',8,'LineStyle','none');
legend([legendParams 'Experimental Data']);
f.CurrentAxes.Children = [f.CurrentAxes.Children(1); f.CurrentAxes.Children(3:5); f.CurrentAxes.Children(2)];

%il testo posso metterlo da 1 a 600 per la x e da 1 a 300 per
%la y



end