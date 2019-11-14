function [ impedance_spectrum_points ] = FouquetL( params, frequencies )

 %                       CPE      
 %              __________\\_________
 %    Romega   |          //        |
 % _L_/\/\/\___|                    |
 %             |_/\/\/\___/warburg/_|        
 %                Rct   
 
 Romega = params(1);
 Rct = params(2); 
 Q = params(3);
 phi = params(4);
 Rd = params(5);
 tauD = params(6);
 L = params(7);
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE = Q .* (1i.* puls).^phi;
 
 ZRomega = Romega + 0.*puls;
 Zcpe = 1./CPE;
 ZRct = Rct + 0.*puls;
 
 ZLhf = (1i*puls*L);
  
 Zpar = (ZRct+war).* Zcpe ./ (ZRct+war+Zcpe);
 impedance_spectrum_points = ZRomega + Zpar + ZLhf;


end

