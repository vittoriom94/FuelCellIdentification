clc
clearvars
close all


% carica dati
load('datiFC.mat');
folder = 'Immagini';
mkdir(folder);

for i=1:length(datiFC)
    fuelcell = datiFC(i);
    % genera impedenza
    impedance = FouquetModel(fuelcell.parameters,fuelcell.frequency);
    
    % stampa le due impedenze
    f = figure('visible','off');
    axis equal
    grid on
    hold on
    plot(real(fuelcell.impedance),-imag(fuelcell.impedance),'Marker','.','MarkerSize',10);
    plot(real(impedance),-imag(impedance),'Marker','.','MarkerSize',10);
    xlabel('Re(Z) [\Omega]');
    ylabel('-Im(Z) [\Omega]');
    legend('Impedenza misurata','Impedenza generata');
    
    % salva grafico

    saveas(f,[folder, '/', num2str(i)],'jpg');
    % chiudi grafico
    close(f);

end




function [ impedance_spectrum_points ] = FouquetModel( params, frequencies  )
%FOUQUETMODEL La funzione, sulla base dei parametri , calcola lo
%spettro di impedenza equivalente nei punti in frequenza forniti
%
%    Romega         CPE
% ___/\/\/\___________\\___________
%           |         //         |
%           |                    |
%           |_/\/\/\___/warburg/_|
%              Rct
Romega = params(1);
Rct = params(2);
Q = params(3);
phi = params(4);
Rd = params(5);
tauD = params(6);
puls = 2 * pi .* frequencies;

rad = sqrt(1i.*puls*tauD);
war = Rd .* tanh(rad)./rad;

CPE = Q .* (1i.* puls).^phi;

ZRomega = Romega + 0.*puls;
Zcpe = 1./CPE;
ZRct = Rct + 0.*puls;

Zpar = (ZRct+war).* Zcpe ./ (ZRct+war+Zcpe);
impedance_spectrum_points = ZRomega + Zpar;


end