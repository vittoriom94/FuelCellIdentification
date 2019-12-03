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

printConModello(dataFitAndClass(3).params{1},chosenImages(3).data.FrequencyHz,@DhirdeSimple,'dhirdesimple',1)
printConModello(dataFitAndClass(12).params{2},chosenImages(12).data.FrequencyHz,@DhirdeL,'dhirdel',2)
printConModello(dataFitAndClass(85).params{3},chosenImages(85).data.FrequencyHz,@DhirdeLWARL,'dhirdewarburg',3)

% dataLowFreq =load('../ImportData\Fuel Starvation\170410_1200_DT46_FS-P9_EIS-15Aprocessed/c03.mat');
% dataRandomPoint = load('../ImportData\Cathode Starvation\170420_1305_DT46_CA-P1_EIS-40Aprocessed/c02.mat');
% dataHighFreq = load('../ImportData\Air Starvation\171117_1025_DT46_AS-P3_EIS-40Aprocessed/c03.mat');
% dataTail = load('../ImportData\Fuel Starvation\170209_1330_DT46_FS-P7_EIS_15Aprocessed/c00.mat');
% printBode(struct('data',dataLowFreq),'lowfreq');
% printBode(struct('data',dataRandomPoint),'randompoint');
% printBode(struct('data',dataHighFreq),'highfreq');
% printBode(struct('data',dataTail),'tail');
% printInductance(chosenImages(1).data.FrequencyHz);

% printWarburg(chosenImages(1).data.FrequencyHz);

% differentROmega(chosenImages(1).data.FrequencyHz);
% differentRC(chosenImages(1).data.FrequencyHz);
% n1 = 92;
% n2 = 7;
% n3 = 112;
% multipleNyquist(chosenImages(n1),chosenImages(n2),chosenImages(n3));
% 

% n = 1;
% bodeAndNyquist(chosenImages(n));


%
% n=70;
% stampaRisultato(dataFitAndClass,chosenImages,n)
% n=110;
% stampaRisultato(dataFitAndClass,chosenImages,n)
% n=108;
% stampaRisultato(dataFitAndClass,chosenImages,n)
%
function printConModello(params,freqs,model,name,modelN)
Z = model(params,freqs);
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z),-imag(Z),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');
legend(['Data generated with Model ' num2str(modelN)] );
saveas(f,['immaginiFinali/' name],'png');
close(f)
end


function printBode(img,name)
Z1 = img.data.realPartOfImpedance +1i*img.data.imagPartOfImpedance;
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');
legend('Experimental Data');
saveas(f,['immaginiFinali/' name],'png');
close(f)
end

function printInductance(freq)
names = {'L - R||C'};
Z1 =inductanceRC([0.000005 0.2 0.1],freq);
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');

legend(names);
saveas(f,'immaginiFinali/inductance','png');
close(f)

end

function printWarburg(freq)
names = {'Warburg || L','Warburg'};
Z1 =ZwarburgL([0.5 0.5 5],freq);
Z2 =Zwarburg([0.5 0.5],freq);
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');
 plot(real(Z2),-imag(Z2),'b',...
     'Marker','.','MarkerSize',10,'MarkerFaceColor','b');
% plot(real(Z3),-imag(Z3),'r',...
%     'Marker','h','MarkerSize',5,'MarkerFaceColor','r');
legend(names);
saveas(f,'immaginiFinali/warburg','png');
close(f)

end

function differentRC(freq)
Z1 = RRRCCModel([0; 0.5; 0.5; 0.05; 2],freq);
Z2 = RRRCCModel([0; 0.2; 0.7; 0.01 ; 0.8],freq);
Z3 = RRRCCModel([0; 0.7; 0.2; 0.1; 4],freq);
names = {'R1 = 0.5; C1 = 0.05; R2 = 0.5; C2 = 2','R1 = 0.2; C1 = 0.01; R2 = 0.7; C2 = 0.8','R1 = 0.7; C1 = 0.1; R2 = 0.2; C2 = 4'};
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');
plot(real(Z2),-imag(Z2),'b',...
    'Marker','d','MarkerSize',5,'MarkerFaceColor','b');
plot(real(Z3),-imag(Z3),'r',...
    'Marker','h','MarkerSize',5,'MarkerFaceColor','r');
legend(names);
saveas(f,'immaginiFinali/differentRC','png');
close(f)

end

function differentROmega(freq)
Z1 = RRCModel([0; 0.5; 0.1],freq);
Z2 = RRCModel([0.1; 0.5; 0.1],freq);
Z3 = RRCModel([0.25; 0.5; 0.1],freq);
names = {'R\Omega = 0','R\Omega = 0.1','R\Omega = 0.25'};
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');
plot(real(Z2),-imag(Z2),'b',...
    'Marker','d','MarkerSize',5,'MarkerFaceColor','b');
plot(real(Z3),-imag(Z3),'r',...
    'Marker','h','MarkerSize',5,'MarkerFaceColor','r');
legend(names);
saveas(f,'immaginiFinali/differentROmega','png');
close(f)

end

function multipleNyquist(b1,b2,b3)
Z1 = b1.data.realPartOfImpedance +1i*b1.data.imagPartOfImpedance;
Z2 = b2.data.realPartOfImpedance +1i*b2.data.imagPartOfImpedance;
Z3 = b3.data.realPartOfImpedance +1i*b3.data.imagPartOfImpedance;
names = {'Experimental Data 1','Experimental Data 2','Experimental Data 3'};
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'k',...
    'Marker','.','MarkerSize',10,'MarkerFaceColor','k');
plot(real(Z2),-imag(Z2),'b',...
    'Marker','d','MarkerSize',5,'MarkerFaceColor','b');
plot(real(Z3),-imag(Z3),'r',...
    'Marker','h','MarkerSize',5,'MarkerFaceColor','r');
legend(names);
saveas(f,'immaginiFinali/multipleNyquist','png');
close(f)
end



function bodeAndNyquist(im)
names = 'Experimental Data';
f = figure();
hold on
grid on
axis equal
xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');
Zgen = im.data.realPartOfImpedance +1i*im.data.imagPartOfImpedance;
freqs = im.data.FrequencyHz;
plot(real(Zgen),-imag(Zgen),'k',...
    'Marker','.','MarkerSize',12);
legend(names);
saveas(f,'immaginiFinali/nyquist','png');
close(f)
f = figure();
subplot(2,1,1)
hold on
grid on
set(gca, 'XScale', 'log');
%                 axis equal
xlabel('Frequency [Hz]')
ylabel('Re(Z) [\Omega]');
plot(freqs,real(Zgen),'k',...
    'Marker','.','MarkerSize',12);

subplot(2,1,2)
hold on
grid on
set(gca, 'XScale', 'log');
%                 axis equal
xlabel('Frequency [Hz]')
ylabel('-Im(Z) [\Omega]');

plot(freqs,-imag(Zgen),'k',...
    'Marker','.','MarkerSize',12);

hold off
subplot(2,1,1)
legend(names);
saveas(f,'immaginiFinali/bode','png');
close(f)


end

function stampaRisultato(dataFitAndClass,chosenImages,n)
d = dataFitAndClass(n);
% figura
f = figure()
hold on
grid on
axis equal
Zgen = chosenImages(n).data.realPartOfImpedance +1i*chosenImages(n).data.imagPartOfImpedance;
freq = chosenImages(n).data.FrequencyHz;
Z1 = DhirdeSimple(d.params{1},freq);
Z2 = DhirdeL(d.params{2},freq);
Z3 = DhirdeLWARL(d.params{3},freq);

xlabel('Re(Z) [\Omega]');
ylabel('-Im(Z) [\Omega]');

plot(real(Z1),-imag(Z1),'b','Marker','.','MarkerSize',12);
plot(real(Z2),-imag(Z2),'r','Marker','.','MarkerSize',12);
plot(real(Z3),-imag(Z3),'g','Marker','.','MarkerSize',12);

plot(real(Zgen),-imag(Zgen),'k',...
    'Marker','o','MarkerSize',8,'LineStyle','none');
legend('Model 1','Model 2','Model 3','Experimental Data');
saveas(f,['immaginiFinali/' num2str(n)],'png');
close(f)
% stampa di:
% errore LF, parametri, variazione

fprintf('\n\nCurva %d\n',n);
fprintf('Errore LF %.4f %.4f %.4f',d.errors{1,3},d.errors{2,3},d.errors{3,3});
fprintf('\nParametri\n');
percSign = '%';
for i=1:14
    if i>11
        fprintf('-\t-\t%.4g\n',d.params{3}(i));
    elseif i>8
        fprintf('-\t%.4g\t%.4g (%.2f%s)\n',d.params{2}(i),d.params{3}(i),100*d.variations{3}(i),percSign);
    else
        fprintf('%.4g\t%.4g (%.2f%s)\t%.4g (%.2f%s)\n',d.params{1}(i),d.params{2}(i),100*d.variations{2}(i),percSign,d.params{3}(i),100*d.variations{3}(i),percSign);
    end
    
end

fprintf('\nvar1to2\n')
for i=1:length(d.variations{2})
    fprintf('%.2f%s\n',100*d.variations{2}(i),percSign);
end
fprintf('\nvar2to3\n')
for i=1:length(d.variations{3})
    fprintf('%.2f%s\n',100*d.variations{3}(i),percSign);
end

end