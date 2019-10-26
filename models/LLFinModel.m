function [ impedance_spectrum_points ] = LLFinModel( params, frequencies )

 %                       CPE      
 %              __________\\________
 %     Romega  |          //        |
 % ___/\/\/\___|                    |
 %             |_/\/\/\___/warburg/_|        
 %                Rct   |           |
 %                      |     L     |
 %                      |___OOOOO___|
 %
 
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
 ZL = (1i.*puls*L);
 
 ZparWL = (ZL.*war)./(ZL+war);
 Zpar = ((ZRct+ZparWL).* Zcpe) ./ (ZRct+ZparWL+Zcpe);
 impedance_spectrum_points = ZRomega + Zpar;


end

