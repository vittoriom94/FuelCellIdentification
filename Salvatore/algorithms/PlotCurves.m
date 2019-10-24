function y = PlotCurves(funcIn,info, environment)

plot(real(environment(:,1)),-imag(environment(:,1)),'k','Marker','.','MarkerSize',16,'LineWidth',2); 
hold on;
grid on;
axis equal;
[~,index] = sortrows([info.fobj].'); info = info(index); clear index

for c = 1 : 1
    punti_generati_individuo = funcIn(info(c).bestInd, environment(:,2));
    plot(real(punti_generati_individuo),-imag(punti_generati_individuo),'r','Marker','.','MarkerSize',16,'LineWidth',2);
end

xlabel 'Re(Z) [\Omega]'
ylabel '-Im(Z) [\Omega]';

y = 1;
end