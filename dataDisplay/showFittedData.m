function showFittedData(realPartReference,imagPartReference,realPartFitting,imagPartFitting,cellName,shouldSave)

    f = figure;
    hold on
    plot(realPartReference,-imagPartReference)
    plot(realPartFitting,-imagPartFitting)
    legend('Reference','Fitting')
    xlabel('Re(Z)') 
    ylabel('-Im(Z)')
    grid on
    
    g = figure;
    hold on
    plot(realPartReference,-imagPartReference,'o')
    plot(realPartFitting,-imagPartFitting,'+')
    legend('Reference','Fitting')
    xlabel('Re(Z)') 
    ylabel('-Im(Z)')
    grid on
    if shouldSave == true
        mkdir('./images/');
        saveas(f,['./images/' replace(cellName,' ','_')],'png');
        saveas(g,['./images/' replace(cellName,' ','_') '_p'],'png');
    end

end