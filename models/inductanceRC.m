function [ impedance_spectrum_points ] = RRCModel( params, frequencies  )
%RRCMODEL  La funzione, sulla base dei parametri , calcola ,lo
%spettro di impedenza equivalente nei punti in frequenza forniti
 %      R1        R2       
 % ___/\/\/\____/\/\/\___
 %           |         |        
 %           |___//____|        
 %              // C  
 
 L = params(1);
 R2 = params(2);
 C = params(3);
 
 puls = 2 * pi .* frequencies;
 
 ZL = (1i*puls*L);
 ZR2 = R2 + 0.*puls;
 ZC = 1./(1i*puls*C);
 
 % calcolo il parallelo tra R2 e C
 Zpar = (ZR2.*ZC)./ (ZR2+ZC);
 
 % calcolo la serie tra R1 e il parallelo di R2 e C
 Zser = ZL + Zpar;
 
 impedance_spectrum_points = Zser;


end

