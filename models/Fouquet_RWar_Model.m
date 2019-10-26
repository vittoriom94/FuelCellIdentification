function [ impedance_spectrum_points ] = Fouquet_RWar_Model( params, frequencies )

 %
 %                        CPE                        R
 %                _________\\___________      ____ /\/\/\_____
 %      Romega    |        //           |    |                |
 %  ___/\/\/\____ |                     |____|                |
 %                |_/\/\/\___/warburg1/_|    |___/warburg2/___|
 %                    Rct                           
 
 Romega = params(1);
 Rct = params(2); 
 Q = params(3);
 phi = params(4);
 Rd1 = params(5);
 tauD1 = params(6);
 R = params(7);
 Rd2 = params(8);
 tauD2 = params(9);
 
 puls = 2 * pi .* frequencies;
 
 rad1 = sqrt(1i.*puls*tauD1);
 war1 = Rd1 .* tanh(rad1)./rad1;
 rad2 = sqrt(1i.*puls*tauD2);
 war2 = Rd2 .* tanh(rad2)./rad2;
 
 CPE = Q .* (1i.* puls).^phi;
 
 ZRomega = Romega + 0.*puls;
 Zcpe = 1./CPE;
 ZRct = Rct + 0.*puls;
 ZR = R + 0.*puls;
 
 Zpar = (ZRct+war1).* Zcpe ./ (ZRct+war1+Zcpe);
 ZparRWar = (ZR.*war2)./(ZR+war2);
 impedance_spectrum_points = ZRomega + Zpar + ZparRWar;

end

