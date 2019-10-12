function newZ = generateFromImpedance(Z,amount)

Zr = real(Z);
Zi = imag(Z);

figure()
hold on
% plot(Zr,-Zi,'-+r');
newZ = cell(amount,1);
for i=1:amount
    
    weights = [0.35*rand(1,12) (0.5+0.5*rand(1,36)).*linspace(0.1,1,36)];
    noise = weights'.*0.075.*(rand(48,2)-0.5);

    scalingFactor =  0.5*rand()+0.75; %scalare
    costantAddReal = max(abs(Zr))*0.2*rand()-0.1; %costante per parte reale
    costantAddImag = max(abs(Zi))*0.2*rand()-0.1; %costante per parte imag
    rotateFactor  = 10*rand()-5;% gradi 
    data = scalingFactor*Z;
    data = (real(data)+real(data).*noise(:,1))+1i*(imag(data)+imag(data).*noise(:,2));
    

    % questo non dovrebbe servirmi perchè poi il riporto nell'origine
%     data = costantAddReal+real(data)+1i*(costantAddImag+imag(data));
    noShow = figure('Visible',false);
    plotObject = plot(real(data),-imag(data));
    rotate(plotObject,[0 0 1], rotateFactor);
    data = get(plotObject,'XData') -1i*get(plotObject,'YData'); 
    close(noShow);
%     plot(real(data),-imag(data),'-k')
    newZ{i} = data';
end



end

% rumore lineare
% rumore pesato
% moltiplica tutto per un fattore
% aggiungi una costante
% ruota rotate(h,[0 0 1],1), h è la linea fatta con plot
% poi faccio x=get(h,'Xdata') y=get(h,'Ydata')
