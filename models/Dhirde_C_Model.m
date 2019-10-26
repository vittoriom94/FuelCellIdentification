function [ impedance_spectrum_points ] = Dhirde_C_Model( params, frequencies )

%                   CPE 1               C 
%               _____\\______      _____//_____       __/warburg/__
%    Romega    |     //     |     |     //     |     |             |  
% ___/\/\/\____|            |-----|            |-----|             |  
%              |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
%                   Rct 1              Rct 2                L

 Romega = params(1);
 Rct1 = params(2);
 Rct2 = params(3);
 Q = params(4);
 phi = params(5);
 Rd = params(6);
 tauD = params(7);
 L = params(8);
 C = params(9);
 
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE1 = Q .* (1i.* puls).^phi;
 
 ZRomega = Romega + 0.*puls;
 ZRct1 = Rct1 + 0.*puls;
 ZRct2 = Rct2 + 0.*puls;
 ZL = (1i*puls*L);
 Zcpe1 = 1./CPE1;
 ZC = 1./(1j*puls*C);
 
 Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);
 Zpar2 = (ZC.*ZRct2)./(ZC+ZRct2);
 Zpar3 = (ZL.*war)./(ZL+war);
 impedance_spectrum_points = ZRomega + Zpar1+ Zpar2+ Zpar3;
end

