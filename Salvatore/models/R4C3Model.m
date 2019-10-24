function [ impedance_spectrum_points ] = R4C3Model( params, frequencies )
 %% Terzo modello - individua lo spettro di impedenza di un secondo circuito leggermente pi� complicato
 %      R1       R2          R3         R4
 % ___/\/\/\___/\/\/\______/\/\/\_____/\/\/\____
 %           |         |  |       | |         |
 %           |___//____|  |__//___| |___//____|
 %              // C2       // C3      // C4

 R1 = params(1);
 R2 = params(2); 
 R3 = params(3);
 R4 = params(4);
 C2 = params(5);
 C3 = params(6);
 C4 = params(7);
 puls = 2 * pi .* frequencies;

 % calcolo le impedenze
 ZR1 = R1 + 0.*puls;
 ZR2 = R2 + 0.*puls;
 ZC2 = 1./(1i*puls*C2);
 ZR3 = R3 + 0.*puls;
 ZC3 = 1./(1i*puls*C3);
 ZR4 = R4 + 0.*puls;
 ZC4 = 1./(1i*puls*C4);
 
 
 % calcolo il parallelo tra R2 e C2 
 ZparR2C2 = (ZR2.*ZC2)./ (ZR2+ZC2);
 
 %calcolo il parallelo tra R3 e C3
 ZparR3C3 = (ZR3.*ZC3)./(ZR3+ZC3);
 
  %calcolo il parallelo tra R3 e C3
 ZparR4C4 = (ZR4.*ZC4)./(ZR4+ZC4);
 
 %calcolo della serie tra i due paralleli e la resistenza R1
 Zser = ZR1 + ZparR2C2 + ZparR3C3 + ZparR4C4;
 
  impedance_spectrum_points = Zser;
    

end

