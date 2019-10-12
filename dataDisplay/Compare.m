classdef Compare < handle
    
    methods(Static)
        function showLocalMinimums(fullData,datiSalvatore,confidenceStats)
            %tutte le curve, solo funzione standard
            paramGen = [
                [0.042601949005868   0.007819104020238   0.866449248201646   0.403582924112081   0.190895929505232   0.003302367520070],
                [0.046521394284818   0.003753149072043   0.780158025046056   0.447492338350717   0.190936675801375   0.002850275912523],
                [0.038317022580635   0.006481566882903   0.811843417500357   0.398309207755147   0.271920936127979   0.008470147744668],
                [0.044379063970248   0.167764751041029   0.668584878656973   0.487849061272363   0.025097184660486   0.000736295864521],
                [0.043047157091489   0.005415292701746   0.585283335624170   0.435322435838454   0.361974846280780   0.015418031890172]
            ];
            folder = 'images/confrontoMinimi/';
            for c=1:size(fullData,1)
                res = fullData{c,3};
                conf = confidenceStats{c,1};
                Z=cell(1,4+2*size(conf,2));
                % params=cell(size(conf,2),1);
                 plotNames = cell(2+size(conf,2),1);
                 plotNames{1,1} = 'Dati sperimentali';
                
                Z{1} = -fullData{c,1}.realPartOfImpedance;
                Z{2} = -fullData{c,1}.imagPartOfImpedance;
                for j=1:size(conf,2)
                    plotNames{j+1,1} = ['Gruppo ' num2str(j) ' LSQ'];
                    [index, resid] = conf{1,j}{1,:};
                    params = res.params{index};
                    Zj = FouquetModel(params,fullData{c,1}.FrequencyHz);
                    Z{2*j+1} = real(Zj);
                    Z{2*j+2} = imag(Zj);
                end
                Zgen = FouquetModel(paramGen(c,:),fullData{c,1}.FrequencyHz);
                Z{2*size(conf,2)+3} = real(Zgen);
                Z{2*size(conf,2)+4} = imag(Zgen);
                plotNames{size(conf,2)+2} = 'Gruppo 1 Genetico';
                f = ShowData.showByZ('Confronto minimi',plotNames,Z);
                saveas(f,[folder 'Cella ' num2str(c)],'jpg');
                close all
            end
            
            
        end
        
        function compareAlgorithms(fullData,datiSalvatore)
            folder = 'images/confronto/';
            names = {'Normale';'Fuel Starv';'Cathode Starv';'Anode Starv';'Air Starv'};
            casi = {'Minimi quadrati';'Vettore pesi 1';'Vettore pesi 2';'Normalizzata';'Normalizzata con valore sperimentale'};
            for c=1:5
                mkdir(folder);
                for i=1:5
                    paramsSalvatore = datiSalvatore{c,i};
                    paramsDet = fullData{c,i+2}.minparams;
                    
                    Zsal = FouquetModel(paramsSalvatore,fullData{c,1}.FrequencyHz);
                    Zdet = FouquetModel(paramsDet,fullData{c,1}.FrequencyHz);
                    
                    Z{1} = -fullData{c,1}.realPartOfImpedance;
                    Z{2} = -fullData{c,1}.imagPartOfImpedance;
                    Z{3} = real(Zsal);
                    Z{4} = imag(Zsal);
                    Z{5} = real(Zdet);
                    Z{6} = imag(Zdet);
                    
                    
                    f = ShowData.showByZ([names{c} ' ' casi{i}],{'Reference Points';'Best Fit individual EA';'Best Fit individual LSQCurveFit'},Z);
                    if i == 2 || i == 3
                        [~,lines] = f.Children.Children;
                        line = lines(3);
                        xData = line.XData;
                        yData = line.YData;
                        v = fullData{c,i+2}.factors{1};
                        for p=1:2:length(xData)
                           text(xData(p),yData(p), {'','',['     ', num2str(round(v(p),2))]},'FontSize',6);                            
                        end
                    end
                    
                    
                    saveas(f,[folder names{c} ' ' casi{i}],'jpg');
                    close all
                end
            end
        end
    end
end