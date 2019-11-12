function [ impedance_spectrum_points ] = DhirdeLCPECPE( params, frequencies )

%                                CPE 1              CPE 2
%                            _____\\______      _____\\_____       __/warburg/__
%    Romega      Lhf        |     //     |     |     //     |     |             |  
% ___/\/\/\_____OOOOO_______|            |-----|            |-----|             |  
%                           |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
%                                Rct 1              Rct 2               Llf

 Romega = params(1);
 Rct1 = params(2);
 Rct2 = params(3);
 Q1 = params(4);
 Q2 = params(5);
 phi1 = params(6);
 phi2 = params(7);
 Rd = params(8);
 tauD = params(9);
 Lhf = params(10);
 Llf = params(11);
 Q3 = params(12);
 phi3 = params(13);
 R1 = params(14);
 Q4 = params(15);
 phi4 = params(16);
 R2 = params(17);
 
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE1 = Q1 .* (1i.* puls).^phi1;
 CPE2 = Q2 .* (1i.* puls).^phi2;
 CPE3 = Q3 .* (1i.* puls).^phi3;
 CPE4 = Q4 .* (1i.* puls).^phi4;
 
 ZRomega = Romega + 0.*puls;
 ZRct1 = Rct1 + 0.*puls;
 ZRct2 = Rct2 + 0.*puls;
 ZR1 = R1 + 0.*puls;
 ZR2 = R2 + 0.*puls;
 ZLhf = (1i*puls*Lhf);
 ZLlf = (1i*puls*Llf);
 Zcpe1 = 1./CPE1;
 Zcpe2 = 1./CPE2;
 Zcpe3 = 1./CPE3;
 Zcpe4 = 1./CPE4;
  
 Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);
 Zpar2 = (Zcpe2.*ZRct2)./(Zcpe2+ZRct2);
 Zpar3 = (ZLlf.*war)./(ZLlf+war);
 Zpar4 = (Zcpe3.*ZR1)./(Zcpe3+ZR1);
 Zpar5 = (Zcpe4.*ZR2)./(Zcpe4+ZR2);
 impedance_spectrum_points = ZRomega + ZLhf + Zpar1+ Zpar2+ Zpar3 + Zpar4 + Zpar5;
end

