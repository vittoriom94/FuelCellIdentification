function error = RMSEED(realPartReference,imagPartReference,realPartFitting,imagPartFitting)

    reY = abs(realPartReference);
    reO = abs(realPartFitting);
    imY = abs(imagPartReference);
    imO = abs(imagPartFitting);
    maxreal = max([reY;reO]);
    maximag = max([imY;imO]);

    realdifference = (reY-reO)./maxreal;
    imagdifference = (imY-imO)./maximag;
    sumrealimag = realdifference.^2+imagdifference.^2;
    error = sqrt(sum(sumrealimag)/size(realdifference,1));

end