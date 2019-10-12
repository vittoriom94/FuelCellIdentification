function y = RMSE_Fouquet(x, environment)
    
MaxRealPart = max(real(environment(:,1)));
MaxImagPart = max(-imag(environment(:,1)));

population_points = zeros(size(environment,1),1);
population_points(:,1) = FouquetModel(x(1),x(2),x(3),x(4),x(5),x(6),environment(:,2));

realPartDistance = abs(real(population_points(:,1)) - real(environment(:,1)))/MaxRealPart;
imaginaryPartDistance = abs(imag(population_points(:,1))-imag(environment(:,1)))/MaxImagPart;
somma = realPartDistance.^2+imaginaryPartDistance.^2;
             
rmse = sqrt(sum(somma)/size(environment,1)); 

y = rmse;
end