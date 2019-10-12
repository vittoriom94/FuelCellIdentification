function data = generateUniformData(lowerBound, upperBound,amount)
if length(lowerBound) ~= length(upperBound)
    error("Different lengths");
end
data = rand(amount,length(lowerBound));
for i = 1:length(lowerBound)
   data(:,i) = data(:,i)*upperBound(i)+lowerBound(i); 
end

end