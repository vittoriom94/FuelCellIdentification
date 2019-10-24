clc
clearvars
close all


addpath(genpath('.'));
curveBuonePath = '../Buone/';
images = dir([curveBuonePath,'/*.jpg']);
imagesStruct =  {images.name}';
imagesStruct(:,2) = {0};
dataset = DataSet('../ImportData',imagesStruct);


resultFolder = 'Results Fitting';


datiFC = struct('impedance',[],'frequency',[],'parameters',[],'name',[]);
c = 0;
for i=1:length(dataset.images)
   if endsWith(dataset.images{i,1},resultFolder) == 1
       continue;
   else
       folder = dataset.images{i,1};
       name = dataset.images{i,2};
       code = name(end-6:end-4);
       
       % carico risultati
       resultFiles = dir([folder,'/', resultFolder,'/*.mat']);
       for j=1:length(resultFiles)
          newCode =  resultFiles(j).name(end-6:end-4);
          if code == newCode
              c=c+1;
             results = load([resultFiles(j).folder ,'/', resultFiles(j).name]);
             data = load([folder, '/', code]);
             datiFC(c).impedance = data.realPartOfImpedance+1j*data.imagPartOfImpedance;
             datiFC(c).frequency = data.FrequencyHz;
             datiFC(c).parameters = results.parametri;
             datiFC(c).name = name(1:end-4);

          end
       end
       
       
   end
    
    
end