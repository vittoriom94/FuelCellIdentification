clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));

curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
trainingImages = dataset.classifiedImages(1:20);
chosenImages = dataset.classifiedImages(1:50);

load('testValidationStrict.mat');


startC = 1;
endC = 11;
modelNames = {'DhirdeSimple','DhirdeL','DhirdeLWARL'};
for i=startC:endC
    f = figure();
    hold on
    grid on
    axis equal
    Zspe = chosenImages(i).data.realPartOfImpedance +1i*chosenImages(i).data.imagPartOfImpedance;
    model = set_model_and_bound(modelNames{dataFitAndClass(i).choice});
    Zalg = model(dataFitAndClass(i).params{dataFitAndClass(i).choice},chosenImages(i).data.FrequencyHz);
    Zforced = DhirdeLWARL(result(i).minparams,chosenImages(i).data.FrequencyHz);
    
    plot(real(Zspe),-imag(Zspe),'k','Marker','.','MarkerSize',10);
    plot(real(Zalg),-imag(Zalg),'Marker','.','MarkerSize',10);
    plot(real(Zforced),-imag(Zforced),'Marker','.','MarkerSize',10);
    close(f);
end
