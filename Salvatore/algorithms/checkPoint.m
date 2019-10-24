function imagimpedance = checkPoint(imagPartOfImpedance)
    
    for i=1 : length(imagPartOfImpedance)-2
        media = abs((abs(imagPartOfImpedance(i,1)) + abs(imagPartOfImpedance(i+2,1))))/2;
        media = media*5;
        if(abs(imagPartOfImpedance(i+1,1)) > media)
            imagPartOfImpedance(i+1,1) = (imagPartOfImpedance(i,1) + imagPartOfImpedance(i+2,1))/2;
        end
        
    end
    imagimpedance = imagPartOfImpedance;
end