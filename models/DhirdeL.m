function [ impedance_spectrum_points ] = DhirdeL( params, frequencies )

%                                CPE 1              CPE 2
%                            _____\\______      _____\\_____       __/warburg/__
%    Romega      Lhf        |     //     |     |     //     |     |             |  
% ___/\/\/\_____OOOOO_______|            |-----|            |-----|             |  
%                           |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
%                                Rct 1              Rct 2               Llf

 Romega = params(1);
 Rct1 = params(2);

 Q1 = params(3);

 phi1 = params(4);

 Rd = params(5);
 tauD = params(6);

 Llf = params(7);
  Lhf = params(8);
  Rct2 = params(9);
  Q2 = params(10);
  phi2 = params(11);
  
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE1 = Q1 .* (1i.* puls).^phi1;
 CPE2 = Q2 .* (1i.* puls).^phi2;
 
 ZRomega = Romega + 0.*puls;
 ZRct1 = Rct1 + 0.*puls;
 ZRct2 = Rct2 + 0.*puls;
 ZLhf = (1i*puls*Lhf);
 ZLlf = (1i*puls*Llf);
 Zcpe1 = 1./CPE1;
 Zcpe2 = 1./CPE2;

 Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);
 Zpar2 = (Zcpe2.*ZRct2)./(Zcpe2+ZRct2);
 Zpar3 = (ZLlf.*war)./(ZLlf+war);
 impedance_spectrum_points = ZRomega + ZLhf + Zpar1+ Zpar2+ Zpar3;
end

