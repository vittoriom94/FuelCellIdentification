classdef ImpedanceGroups < handle
    
    methods(Static)

        function convergence = getConvergence(fit,model,freq)
            error = 0.01;
            f = figure();
            hold on
            axis equal
            grid on
            [ model, ~, ~ ] = set_model_and_bound(model);
            startData = model(fit.minparams,freq);
            dist = abs(startData);
            maxDist = max(dist);
            count = 0;
            for i=1:length(fit.params)
                newData = model(fit.params{i},freq);


                newDist = abs(newData);
                over = false;
                for j=1:length(startData)
                    diff = abs(newDist(j)-dist(j));
                    if diff/maxDist > error
                       over = true; 
                    end
                end
                if over == false
                   plot(real(newData),-imag(newData));
                   count = count+1; 
                end
            end
            
            convergence = count/length(fit.params);
            close(f);
        end
    end
end