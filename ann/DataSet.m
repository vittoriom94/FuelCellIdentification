classdef DataSet < handle
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        images
        classifiedImages
        classifier
    end
    
    methods
        function obj = DataSet(folder, classifierFile)
            obj.images = obj.loadData(folder);
            classifier = load(classifierFile);
            obj.classifier = classifier.classifier;
            obj.classifiedImages = obj.loadImpedance();
            
            
        end
        function images = loadData(obj, folder)
            images = {};
            files = dir(folder);
            for i=1:length(files)
                file = files(i);

                if strcmp(file.name,'.') == 1 || strcmp(file.name,'..') == 1
                    continue;
                elseif file.isdir == 1
                    newImages = obj.loadData([file.folder '/' file.name]);
                    images = [images; newImages];
                elseif endsWith(file.name,'.jpg') == 1
                    image = {file.folder , file.name};
                    images(end+1,:) = image;
                end
                
            end
        end
        function impedances = loadImpedance(obj)
            for i=1:size(obj.classifier,1)
               name = obj.classifier{i,1};
               ind = find(strcmp(obj.images(:,2), name));
               if isempty(ind) == 0
                   code = name(end-6:end-4);
                   fName = [obj.images{ind,1} '/' code '.mat'];
                   data = load(fName);
                   imp = struct('data',data,'folder',obj.images{ind,1},'code',code,'name',name,'class',obj.classifier{i,2});
                   impedances(i) = imp;

                   
               end
               
            end
            
        end

    end
end

