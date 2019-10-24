function [ impedance_spectrum_points ] = AsghariModel( params, frequencies )
%ASGHARIMODEL La funzione, sulla base dei parametri , calcola lo
%spettro di impedenza equivalente nei punti in frequenza forniti
%
%                              CPE 1              CPE 2
%                          _____\\______      _____\\_____
%      Rm         L       |     //     |     |     //     |
% ___/\/\/\_____OOOOO_____|            |-----|            |-----
%                         |___/\/\/\___|     |___/\/\/\___|
%                              Rct                 Rmt   
Rm = params(1);
Rct = params(2); 
Rmt = params(3); 
Q1 = params(4);
Q2 = params(5);
phi1 = params(6);
phi2 = params(7);
L = params(8);

puls = 2 * pi .* frequencies;

CPE1 = Q1 .* (1i.* puls).^phi1;
CPE2 = Q2 .* (1i.* puls).^phi2;

Zm = Rm + 0.*puls;
Zct = Rct + 0.*puls;
Zmt = Rmt + 0.*puls;
ZL = (1i.*puls*L);
Zcpe1 = 1./CPE1;
Zcpe2 = 1./CPE2;

Zpar1 = (Zct.*Zcpe1)./(Zct+Zcpe1);
Zpar2 = (Zmt.*Zcpe2)./(Zmt+Zcpe2);

impedance_spectrum_points = Zm + ZL + Zpar1 + Zpar2;

end

