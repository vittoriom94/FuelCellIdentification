classdef PrintData < handle
    %SHOWDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        function displayAll(fullData,confidenceStats)

            for f=3:size(fullData,2)
                fprintf("\nFitting numero %d\n\n",f-2);
%                 graphNames = {'Normal';'Fuel Starvation';'Cathode Starvation';'Anode Starvation';'Air Starvation'};
                for i=1:size(fullData,1)
                    close all;
                    res = fullData{i,f};
                    conf = confidenceStats{i,f-2};
                    fprintf('\nCella numero %d\n\n',i);
                    Z=cell(1,2*size(conf,2));
%                     params=cell(size(conf,2),1);
%                     plotNames = cell(1+size(conf,2),1);
%                     plotNames{1,1} = 'Dati sperimentali';
                    
                    Z{1} = -fullData{i,1}.realPartOfImpedance;
                    Z{2} = -fullData{i,1}.imagPartOfImpedance;
                    for j=1:size(conf,2)
                        [index, resid] = conf{1,j}{1,:};
                        dataSize = 48;
                        rmse = sqrt(resid/dataSize);
                        PrintData.displayForFile(res.params{index},conf{2,j},conf{3,j},resid,rmse);
                        
                    end
                    
                end
            end
        end
        function displayForFile(params, confidence, percentage,resid,rmse)
            
            names = {'Romega','Rct','Q','Phi','Rd','TauD'};
            for i=1:length(names)
                lowerDiff = (params(i) - confidence(i,1) );
                upperDiff = (confidence(i,2) - params(i));
                variation = abs((abs(lowerDiff)-abs(upperDiff))/params(i)*100);
                tolerance = 2;
                if variation > tolerance
                    percString = ['-' num2str(lowerDiff/params(i)*100,'%.4g') '%; +' num2str(upperDiff/params(i)*100,'%.4g') '%'];
                else
                    percString = ['±' num2str(percentage(i)/2*100,'%.2f') '%'];
                end
                fprintf('%s = %.5f [%.5f ; %.5f] (%s);\n',names{i},params(i),confidence(i,1),confidence(i,2),percString);
            end
            fprintf('\nFobj = %.4e;\nRmse = %.6f %s;\n',resid,rmse,char(hex2dec('03a9')));
            
            fprintf('\n');
        end
        
    end
end