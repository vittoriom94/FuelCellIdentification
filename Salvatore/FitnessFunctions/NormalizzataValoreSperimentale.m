function y = NormalizzataValoreSperimentale(funcIn,x, environment)
    
population_points = zeros(size(environment,1),1);
population_points(:,1) = funcIn(x,environment(:,2));

numRealPartDistance = real(population_points(:,1)) - real(environment(:,1));
divRealPartDistance = numRealPartDistance./real(environment(:,1));
realPartDistance = abs(divRealPartDistance)

numImaginaryPartDistance = imag(population_points(:,1))-imag(environment(:,1));
divRealPartDistance = numImaginaryPartDistance./imag(environment(:,1));
imaginaryPartDistance = abs(divRealPartDistance)

pitagora = realPartDistance.^2 + imaginaryPartDistance.^2;
             
fitness = sum(pitagora); 

y = fitness;
end