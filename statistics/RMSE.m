function error = RMSE(Zexp,Zgen)
    dataSize = length(Zexp);
    rpDist = abs(real(Zexp) - real(Zgen));
    imDist = abs(imag(Zexp) - imag(Zgen));

    error = sqrt(sum(rpDist.^2+imDist.^2)/dataSize);
end