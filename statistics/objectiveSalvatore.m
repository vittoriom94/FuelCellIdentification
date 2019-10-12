function y = objectiveSalvatore(x, environment)

population_points = zeros(size(environment,1),1);
population_points(:,1) = FouquetModel(x,environment(:,2));

realPartDistance = abs(real(population_points(:,1)) - real(environment(:,1)));
imaginaryPartDistance = abs(imag(population_points(:,1))-imag(environment(:,1)));
pitagora = realPartDistance.^2+imaginaryPartDistance.^2;
             
fitness = sum(pitagora); 

y = fitness;
end