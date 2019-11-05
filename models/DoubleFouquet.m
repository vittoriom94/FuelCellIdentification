function [ impedance_spectrum_points ] = DoubleFouquet( params, frequencies )

 %                       CPE1                    CPE2
 %              __________\\_________   __________\\_________
 %    Romega   |          //        |  |          //        |
 % ___/\/\/\___|                    |__|                    |
 %             |_/\/\/\__/warburg1/_|  |_/\/\/\__/warburg2/_|     
 %                Rct1                     Rct2
 
 Romega = params(1);
 Rct1 = params(2); 
 Q1 = params(3);
 phi1 = params(4);
 Rd1 = params(5);
 tauD1 = params(6);
 
 Rct2 = params(7); 
 Q2 = params(8);
 phi2 = params(9);
 Rd2 = params(10);
 tauD2 = params(11);
 
 puls = 2 * pi .* frequencies;
 ZRomega = Romega + 0.*puls;
  
 rad1 = sqrt(1i.*puls*tauD1);
 war1 = Rd1 .* tanh(rad1)./rad1;

 CPE1 = Q1 .* (1i.* puls).^phi1;
 
 Zcpe1 = 1./CPE1;
 ZRct1 = Rct1 + 0.*puls;

 Zpar1 = (ZRct1+war1).* Zcpe1 ./ (ZRct1+war1+Zcpe1);
 %---%
 rad2 = sqrt(1i.*puls*tauD2);
 war2 = Rd2 .* tanh(rad2)./rad2;

 CPE2 = Q2 .* (1i.* puls).^phi2;
 
 Zcpe2 = 1./CPE2;
 ZRct2 = Rct2 + 0.*puls;

 Zpar2 = (ZRct2+war2).* Zcpe2 ./ (ZRct2+war2+Zcpe2);
 
 impedance_spectrum_points = ZRomega + Zpar1 + Zpar2;


end





 %                       CPE1               CPE2
 %              __________\\_________   ___\\_____   ___/warburg2/__
 %    Romega   |          //        |  |   //    |   |             |
 % ___/\/\/\___|                    |__|         |___|             |
 %             |_/\/\/\__/warburg1/_|  |_/\/\/\__|   |___/indutt/---
 %                Rct1                     Rct2



