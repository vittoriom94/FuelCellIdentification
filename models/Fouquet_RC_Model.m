function [ impedance_spectrum_points ] = Fouquet_RC_Model( params, frequencies  )
%FOUQUETMODEL La funzione, sulla base dei parametri , calcola lo
%spettro di impedenza equivalente nei punti in frequenza forniti
%
 %
 %
 %                        CPE                       R
 %                _________\\___________     ____ /\/\/\____
 %      Romega    |        //          |    |               |
 %  ___/\/\/\____ |                    |____|               |
 %                |_/\/\/\___/warburg/_|    |_______//______|
 %                    Rct                           // C
 
 Romega = params(1);
 Rct = params(2); 
 Q = params(3);
 phi = params(4);
 Rd = params(5);
 tauD = params(6);
 R = params(7);
 C = params(8);
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE = Q .* (1i.* puls).^phi;
 
 ZRomega = Romega + 0.*puls;
 Zcpe = 1./CPE;
 ZRct = Rct + 0.*puls;
 ZR = R + 0.*puls;
 ZC = 1./(1j*puls*C);
 
 Zpar = (ZRct+war).* Zcpe ./ (ZRct+war+Zcpe);
 ZparRC = (ZR.*ZC)./(ZR+ZC);
 impedance_spectrum_points = ZRomega + Zpar + ZparRC;


end

