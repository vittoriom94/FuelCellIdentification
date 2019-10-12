function f = showParameters(data,confidenceIntervals)
lowerBound = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
upperBound = [0.1 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];

f = figure();
hold on
grid on
xlim([0 7])
ylim([0 1])
colors = [0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250;
    0.6350    0.0780    0.1840];

xlabel('Parametri');
ylabel('Valore');

xticklabels({'','R_{\Omega}','R_{ct}','Q','Phi','R_d','tauD',''});
ax1 = gca;
ax2 = axes('XAxisLocation','top','YColor','none');
xlim([0 7]);
xticklabels({'','x0.1','x0.5','x1.0','x1.0','x0.5','x4.0'});

axes(ax1);

for c=2:size(confidenceIntervals,2)
    pointsX = zeros(length(data{1,2}(1,:))*size(confidenceIntervals{1,c},1),1);
    pointsY = zeros(length(data{1,2}(1,:))*size(confidenceIntervals{1,c},1),1);
    
    for i=1:size(confidenceIntervals{1,c},1)
        ind = confidenceIntervals{1,c}{i,1};
        params = data{1,2}(ind,:);
        for p=1:length(params)
            pointsX(((i-1)*length(params))+p) = p;
            pointsY(((i-1)*length(params))+p) = params(p)/upperBound(p);
        end
    end
    p = plot(pointsX,pointsY,'Marker','.','MarkerSize',8,'LineStyle','none');
    
    firstIndex = confidenceIntervals{1,c}{1,1};
    params = data{1,3}.params{firstIndex,:};
    pointsX = zeros(length(params),1);
    pointsY = zeros(length(params),1);
    color = get(p,'Color');
    for p=1:length(params)
        pointsX(p) = p;
        pointsY(p) = params(p)/upperBound(p);
        a=1;
    end
    plot(pointsX,pointsY,'Marker','p','MarkerSize',9,'MarkerFaceColor',color,'LineStyle','none','Color',color);
end

params = data{1,3}.minparams;
pointsX = zeros(length(params),1);
pointsY = zeros(length(params),1);

for p=1:length(params)
    pointsX(p) = p;
    pointsY(p) = params(p)/upperBound(p);
end
plot(pointsX,pointsY,'Marker','p','MarkerSize',9,'MarkerFaceColor','k','LineStyle','none','Color','k');


end