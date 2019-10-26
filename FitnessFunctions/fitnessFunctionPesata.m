function y = fitnessFunctionPesata(funcIn,x, environment)

% Vengono annullati gli ultimi due campioni

%vect = [ones(1,24),linspace(0.8, 0.2, 24)];
vect = [ones(24,1);linspace(0.8, 0.2, 22)'; zeros(2,1)];
population_points = zeros(size(environment,1),1);
population_points(:,1) = funcIn(x,environment(:,2));

realPartDistance = abs(real(population_points(:,1)) - real(environment(:,1))).*vect(1,:)';
imaginaryPartDistance = abs(imag(population_points(:,1))-imag(environment(:,1))).*vect(1,:)';
pitagora = realPartDistance.^2+imaginaryPartDistance.^2;
             
fitness = sum(pitagora);

y = fitness;
end