function [ impedance_spectrum_points ] = DhirdeSimple( params, frequencies )

%                   CPE 1              CPE 2
%               _____\\______      _____\\_____       __/warburg/__
%     Romega   |     //     |     |     //     |     |             |  
% ___/\/\/\____|            |-----|            |-----|             |  
%              |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
%                   Rct 1              Rct 2                L

% senza un cappio CPE e con l'induttore serie
 Romega = params(1);
 Rct1 = params(2);

 Q1 = params(3);

 phi1 = params(4);

 Rd = params(5);
 tauD = params(6);
 L = params(7);
 L2 = params(8);
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE1 = Q1 .* (1i.* puls).^phi1;

 
 ZRomega = Romega + 0.*puls;
 ZRct1 = Rct1 + 0.*puls;

 ZL = (1i*puls*L);
 Zcpe1 = 1./CPE1;

 ZLhf = (1i*puls*L2);
 Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);

 Zpar3 = (ZL.*war)./(ZL+war);
 impedance_spectrum_points = ZRomega + Zpar1+ Zpar3 + ZLhf;
end

