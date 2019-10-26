function [ impedance_spectrum_points ] = AsghariModel_War_Model( params, frequencies )

%                              CPE 1                    CPE 2
%                          _____\\______      ___________\\__________
%      Rm         L       |     //     |     |           //          | 
% ___/\/\/\_____OOOOO_____|            |-----|                       |----
%                         |___/\/\/\___|     |___/\/\/\___/warburg/__|
%                              Rct                 Rmt   

Rm = params(1);
Rct = params(2); 
Rmt = params(3); 
Q1 = params(4);
Q2 = params(5);
phi1 = params(6);
phi2 = params(7);
L = params(8);
Rd = params(9);
tauD = params(10);

puls = 2 * pi .* frequencies;

rad = sqrt(1i.*puls*tauD);
war = Rd .* tanh(rad)./rad;

CPE1 = Q1 .* (1i.* puls).^phi1;
CPE2 = Q2 .* (1i.* puls).^phi2;

Zm = Rm + 0.*puls;
Zct = Rct + 0.*puls;
Zmt = Rmt + 0.*puls;
ZL = (1i.*puls*L);
Zcpe1 = 1./CPE1;
Zcpe2 = 1./CPE2;

Zpar1 = (Zct.*Zcpe1)./(Zct+Zcpe1);
Zpar2 = ((Zmt+war).*Zcpe2)./(Zmt+war+Zcpe2);
 
impedance_spectrum_points = Zm + ZL + Zpar1 + Zpar2;

end

