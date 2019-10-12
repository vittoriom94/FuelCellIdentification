function residual = initialResidual(measuredZ,fittedZ,factorReal,factorImag)

realDist = abs(real(fittedZ) - real(measuredZ)).*factorReal;
imagDist = abs(imag(fittedZ) - imag(measuredZ)).*factorImag;

residual = sum(realDist.^2 + imagDist.^2);

end