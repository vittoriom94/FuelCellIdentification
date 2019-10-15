classdef NNAnalyzer
    
    
    methods(Static)
        function trainResult = analyzeAll(allWrongs,total,trainAmount)
            trainResult = zeros(size(allWrongs,1),3);
            for i=1:size(allWrongs,1)
                [best, worst, average] = NNAnalyzer.analyze(allWrongs(i,:),total,trainAmount);
                trainResult(i,:) = [best worst average];
            end
        end
        function [best, worst, average] = analyze(wrongs,total,trainAmount)
            best = NNAnalyzer.getBest(wrongs);
            worst = NNAnalyzer.getWorst(wrongs);
            average = NNAnalyzer.getAverage(wrongs);
        end
        function worst = getWorst(wrongs)
            worst = 0;
            for i=1:length(wrongs)
                if i==1 || size(wrongs{i},1) > size(wrongs{worst},1)
                    worst = i;
                end
            end
        end
        function best = getBest(wrongs)
            best = 0;
            for i=1:length(wrongs)
                if i==1 || size(wrongs{i},1) < size(wrongs{best},1)
                    best = i;
                end
            end
        end
        function average = getAverage(wrongs)
            %average = average number of wrongs
            cases = length(wrongs);
            total = 0;
            for i=1:length(wrongs)
                total = total + size(wrongs{i},1);
                
            end
            average = total/cases;
        end
    end
end

