clc
clearvars
close all


% cd(fileparts(which(mfilename)));
addpath(genpath('.'));
% rmparth('Salvatore');
warning('off','MATLAB:singularMatrix');
% scegliere le curve
curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);
chosenImages = dataset.classifiedImages(2:2);
allInfo = zeros(length(chosenImages),3);
for i=1:length(chosenImages)
    i
    Z = chosenImages(i).data.realPartOfImpedance +1i*chosenImages(i).data.imagPartOfImpedance;
    freq = chosenImages(i).data.FrequencyHz;
    [params, model, result,f, info] = fitAndClassify(Z,freq);
    allInfo(i,:) = info;
    saveas(f,['images/fitAndClassify/' num2str(i)],'png');
    close(f);
end