function error = objectiveF(xdata,ydata)
    sum = 0;

    for i=1:length(xdata)
        sum = sum+(xdata(i)-ydata(i))^2;
    end
    error = sum;

end