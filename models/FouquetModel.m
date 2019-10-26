function [ impedance_spectrum_points ] = FouquetModel( params, frequencies )

 %                       CPE      
 %              __________\\_________
 %    Romega   |          //        |
 % ___/\/\/\___|                    |
 %             |_/\/\/\___/warburg/_|        
 %                Rct   
 
 Romega = params(1);
 Rct = params(2); 
 Q = params(3);
 phi = params(4);
 Rd = params(5);
 tauD = params(6);
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE = Q .* (1i.* puls).^phi;
 
 ZRomega = Romega + 0.*puls;
 Zcpe = 1./CPE;
 ZRct = Rct + 0.*puls;

 Zpar = (ZRct+war).* Zcpe ./ (ZRct+war+Zcpe);
 impedance_spectrum_points = ZRomega + Zpar;


end

