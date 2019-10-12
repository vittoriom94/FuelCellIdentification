function [ impedance_spectrum_points ] = AsghariModel( Rm, Rct, Rmt, Q1, Q2, phi1, phi2, L, frequencies )
%ASGHARIMODEL La funzione, sulla base dei parametri , calcola lo
%spettro di impedenza equivalente nei punti in frequenza forniti
%
%                              CPE 1              CPE 2
%                          _____\\______      _____\\_____
%      Rm         L       |     //     |     |     //     |
% ___/\/\/\_____OOOOO_____|            |-----|            |-----
%                         |___/\/\/\___|     |___/\/\/\___|
%                              Rct                 Rmt   
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

