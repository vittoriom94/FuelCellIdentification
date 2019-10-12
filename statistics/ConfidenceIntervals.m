classdef ConfidenceIntervals < handle
    
    methods(Static)
        function confidenceStats = getAllIntervals(fullData)
            confidenceStats = cell(size(fullData,1),size(fullData,2)-2);
            for f=3:size(fullData,2)
                for i=1:size(fullData,1)
                    group = ConfidenceIntervals.getIntervals(fullData{i,f});
                    confidenceStats{i,f-2}= group;
                end
            end
        end
        function groups = getIntervals(data)
            % trovo i gruppi di tolleranze
            groups = {};
            tolerance = 0.05;
            residuals = data.resid;
            
            index = data.index;
            groups{1}(1,:) = {index,residuals(index)};
            
            for i=1:length(residuals)
                if isempty(groups) == true
                    groups{1}(1,:) = {i,residuals(i)};
                else
                    found = false;
                    for j=1:length(groups)
                        upperLimit = groups{j}{1,2}*(1+tolerance);
                        lowerLimit = groups{j}{1,2}*(1-tolerance);
                        if (residuals(i)>= lowerLimit && residuals(i) <= upperLimit) == true
                            groups{j}(end+1,:) = {i,residuals(i)};
                            found = true;
                            break;
                        end
                    end
                    if found == false
                        groups{length(groups)+1}(1,:) = {i,residuals(i)};
                    end
                end
                
            end
            
            %per ogni gruppo prendo il residuo minimo
            for i=1:length(groups)
                [~,index] = min(cell2mat(groups{1,i}(:,2)));
                groups{2,i} = data.conf{groups{1,i}{index,1}};
                for j=1:length(groups{2,i})
                    perc = abs(groups{2,i}(j,1)-groups{2,i}(j,2))/data.params{groups{1,i}{index,1}}(j);
                    groups{3,i}(j) = perc;
                    
                end
                
            end
            % per ogni residuo prendo gli intervalli e riporto quelli + la
            % differenza tra gli intervalli /diviso il valore del parametro
            
        end
        function result = isCentered(batteryData,confidenceStats)
            tolerance = 2;
            result = {};
            for c=1:length(confidenceStats)
                cell = confidenceStats{c,1};
                for g=1:size(cell,2)
                    
                    params = batteryData{c,3}.params{cell{1,g}{1}};
                    for p=1:size(cell{2,g},1)
                        lowerDiff = (params(p) - cell{2,g}(p,1) );
                        upperDiff = (cell{2,g}(p,2) - params(p));
                        variation = abs((abs(lowerDiff)-abs(upperDiff))/params(p)*100);
                        if variation > tolerance
                            result(end+1,:) = {c,g,p,variation,params(p)};
                        end
                    end
                end
                
            end
            
        end
    end
end