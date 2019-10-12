function saveFiguresForStartingCondition(fullData,confidenceIntervals)

for i=1:size(fullData,1)
    savePath = 'images/startingConditions/';
    names = {'NormalCondition'; 'FuelStarvation'; 'CathodeStarvation'; 'AnodeStarvation'; 'AirStarvation'};
    
    f = startConditionsAll(fullData(i,:),confidenceIntervals{i});
    saveas(f,[savePath , names{i},'_all'],'jpg');
    close(f);
    f = startConditionsWrong(fullData(i,:),confidenceIntervals{i});
    saveas(f,[savePath , names{i},'_wrong'],'jpg');
    close(f);
    f = startConditionsExact(fullData(i,:),confidenceIntervals{i});
    saveas(f,[savePath , names{i},'_exact'],'jpg');
    close(f);
end
end


function f =  startConditionsAll(data,confidence)
f = figure();
title('Tutte le curve');
hold on
grid on
axis equal
xlabel('Re(Z) [m\Omega]');
ylabel('-Im(Z) [m\Omega]');

for i=1:length(data{1,2})
    Z = FouquetModel(data{1,2}(i,:),data{1,1}.FrequencyHz);
    color='k';
    plot(real(Z),-imag(Z),'Color',color);
    
end
indexes = confidence{1,1}(:,1);

maxResid = data{1,3}.initialResid{indexes{1}};
maxI = indexes(1);
for j=2:length(indexes)
    
    newResid = data{1,3}.initialResid{indexes{j}};
    if newResid > maxResid
        maxResid = newResid;
        maxI = indexes{j};
    end
    
end

index = maxI;


% [~,index] = max([confidence{1,1}{:,2}]);
Z = FouquetModel(data{1,2}(index,:),data{1,1}.FrequencyHz);
p1 = plot(real(Z),-imag(Z),'Color','red','LineWidth',0.7,'Marker','.','MarkerSize',8);
Z = FouquetModel(data{1,3}.params{index},data{1,1}.FrequencyHz);
p2 = plot(real(Z),-imag(Z),'Color','green','LineWidth',0.7,'Marker','.','MarkerSize',8);
legend([p1 p2],'Curva Iniziale','Curva generata');

xticklabels(floor(xticks*1000));
yticklabels(floor(yticks*1000));

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',7);

a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',7);

end

function f = startConditionsWrong(data,confidence)
f = figure();
title('Solo curve che generano residui maggiori');
hold on
grid on
axis equal
xlabel('Re(Z) [m\Omega]');
ylabel('-Im(Z) [m\Omega]');

indexes = confidence{1,1}(:,1);

maxResid = data{1,3}.initialResid{indexes{1}};
maxI = indexes(1);
for j=2:length(indexes)
    
    newResid = data{1,3}.initialResid{indexes{j}};
    if newResid > maxResid
        maxResid = newResid;
        maxI = indexes{j};
    end
    
end

index = maxI;

residuals = data{1,3}.resid;
for i=1:length(data{1,2})
    
    tolerance = 0.05;
    smallestResid = data{1,3}.resid(data{1,3}.index);
    upperLimit = smallestResid*(1+tolerance);
    lowerLimit = smallestResid*(1-tolerance);
    

    
    initialResid = data{1,3}.initialResid{i};
    
    if (residuals(i)>= lowerLimit && residuals(i) <= upperLimit) == false
        if initialResid > maxResid
           color = [75 79 87]./255;
        else
            color = 'k';
        end
        Z = FouquetModel(data{1,2}(i,:),data{1,1}.FrequencyHz);
        plot(real(Z),-imag(Z),'Color',color);
    end
    
    
end




% [~,index] = max([confidence{1,1}{:,2}]);
Z = FouquetModel(data{1,2}(index,:),data{1,1}.FrequencyHz);
p1 = plot(real(Z),-imag(Z),'Color','red','LineWidth',0.7,'Marker','.','MarkerSize',8);
Z = FouquetModel(data{1,3}.params{index},data{1,1}.FrequencyHz);
p2 = plot(real(Z),-imag(Z),'Color','green','LineWidth',0.7,'Marker','.','MarkerSize',8);
legend([p1 p2],'Curva Iniziale','Curva generata');

xticklabels(round(xticks*1000));
yticklabels(round(yticks*1000));

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',7);

a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',7);

end

function f = startConditionsExact(data,confidence)
f = figure();
title('Solo curve che generano il residuo minore');
hold on
grid on
axis equal
xlabel('Re(Z) [m\Omega]');
ylabel('-Im(Z) [m\Omega]');

for i=1:length(data{1,2})
    
    color='k';
    tolerance = 0.02;
    smallestResid = data{1,3}.resid(data{1,3}.index);
    upperLimit = smallestResid*(1+tolerance);
    lowerLimit = smallestResid*(1-tolerance);
    
    residuals = data{1,3}.resid;
    
    if (residuals(i)>= lowerLimit && residuals(i) <= upperLimit) == true
        Z = FouquetModel(data{1,2}(i,:),data{1,1}.FrequencyHz);
        plot(real(Z),-imag(Z),'Color',color);
    end
    
    
end

indexes = confidence{1,1}(:,1);

maxResid = data{1,3}.initialResid{indexes{1}};
maxI = indexes(1);
for j=2:length(indexes)
    
    newResid = data{1,3}.initialResid{indexes{j}};
    if newResid > maxResid
        maxResid = newResid;
        maxI = indexes{j};
    end
    
end

index = maxI;



% [~,index] = max([confidence{1,1}{:,2}]);
Z = FouquetModel(data{1,2}(index,:),data{1,1}.FrequencyHz);
p1 = plot(real(Z),-imag(Z),'Color','red','LineWidth',0.7,'Marker','.','MarkerSize',8);
Z = FouquetModel(data{1,3}.params{index},data{1,1}.FrequencyHz);
p2 = plot(real(Z),-imag(Z),'Color','green','LineWidth',0.7,'Marker','.','MarkerSize',8);
legend([p1 p2],'Curva Iniziale','Curva generata');

xticklabels(floor(xticks*1000));
yticklabels(floor(yticks*1000));

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',7);

a = get(gca,'YTickLabel');
set(gca,'YTickLabel',a,'fontsize',7);

end
