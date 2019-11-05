function [ impedance_spectrum_points ] = RRRCCModel( params, frequencies )
%RRRCCMODEL Summary of this function goes here
 %      R1       R2          R3
 % ___/\/\/\___/\/\/\______/\/\/\___
 %           |         |  |       |
 %           |___//____|  |__//___|
 %              // C2       // C3  
 
 
 R1= params(1);
 R2 = params(2);
 R3 = params(3);
 C2 = params(4);
 C3 = params(5);
 
 puls = 2 * pi .* frequencies;
% calcolo le impedenze
 ZR1 = R1 + 0.*puls;
 ZR2 = R2 + 0.*puls;
 ZC2 = 1./(j*puls*C2);
 ZR3 = R3 + 0.*puls;
 ZC3 = 1./(j*puls*C3);
 
 % calcolo il parallelo tra R2 e C2 
 ZparR2C2 = (ZR2.*ZC2)./ (ZR2+ZC2);
 
 %calcolo il parallelo tra R3 e C3
 ZparR3C3 = (ZR3.*ZC3)./(ZR3+ZC3);
 
 %calcolo della serie tra i due paralleli e la resistenza R1
 Zser = ZparR2C2 + ZparR3C3 + ZR1;
 
 impedance_spectrum_points = Zser;

end

