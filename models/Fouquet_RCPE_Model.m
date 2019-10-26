function [ impedance_spectrum_points ] = Fouquet_RCPE_Model( params, frequencies )

 %
 %                        CPE1                       R
 %                _________\\___________     ____ /\/\/\____
 %      Romega    |        //          |    |               |
 %  ___/\/\/\____ |                    |____|               |
 %                |_/\/\/\___/warburg/_|    |_______\\______|
 %                    Rct                           // CPE2
 
 Romega = params(1);
 Rct = params(2); 
 Q1 = params(3);
 phi1 = params(4);
 Rd = params(5);
 tauD = params(6);
 R = params(7);
 Q2 = params(8);
 phi2 = params(9);
 
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE1 = Q1 .* (1i.* puls).^phi1;
 CPE2 = Q2 .* (1i.* puls).^phi2;
 
 ZRomega = Romega + 0.*puls;
 Zcpe1 = 1./CPE1;
 Zcpe2 = 1./CPE2;
 ZRct = Rct + 0.*puls;
 ZR = R + 0.*puls;
 
 Zpar = (ZRct+war).* Zcpe1 ./ (ZRct+war+Zcpe1);
 ZparRCPE = (ZR.*Zcpe2)./(ZR+Zcpe2);
 impedance_spectrum_points = ZRomega + Zpar + ZparRCPE;


end

