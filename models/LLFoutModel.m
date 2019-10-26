function [ impedance_spectrum_points ] = LLFoutModel( params, frequencies  )

 %
 %                       CPE      
 %              __________\\________      __/warburg/__
 %     Romega  |          //        |    |             |
 % ___/\/\/\___|                    |____|      L      |____
 %             |_______/\/\/\_______|    |____OOOOO____|     
 %                       Rct
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
 ZL = (1i.*puls*L);
 
 ZRomega = Romega + 0.*puls;
 Zcpe = 1./CPE;
 ZRct = Rct + 0.*puls;

 Zpar = (ZRct.* Zcpe) ./ (ZRct+Zcpe);
 Zparwar = (war.* ZL) ./ (war+ZL);
 impedance_spectrum_points = ZRomega + Zpar + Zparwar;


end

