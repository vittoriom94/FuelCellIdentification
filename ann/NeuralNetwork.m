classdef NeuralNetwork < handle
    properties
        trainingData
        resultData
        net
        trainedNet
    end
    methods
        function loadData(self,trainSet,resultSet)
            self.trainingData = trainSet;
            self.resultData = resultSet;
        end
        function configure(self,layers)
            self.net = patternnet(layers);
        end
        function train(self)
            self.trainedNet = train(self.net,self.trainingData,self.resultData);
        end
        function result = get(self,data)
            result = self.trainedNet(data);
        end
        
    end
    
    
end