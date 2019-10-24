function y = minimiQuadratiNormalizzata(funIn,x, environment)
    
MaxRealPart = max(real(environment(:,1)));
MaxImagPart = max(-imag(environment(:,1)));

population_points = zeros(size(environment,1),1);
population_points(:,1) = funIn(x,environment(:,2));

realPartDistance = abs(real(population_points(:,1)) - real(environment(:,1)))/MaxRealPart;
imaginaryPartDistance = abs(imag(population_points(:,1))-imag(environment(:,1)))/MaxImagPart;
pitagora = realPartDistance.^2+imaginaryPartDistance.^2;

fitness = sum(pitagora); 

y = fitness;
end