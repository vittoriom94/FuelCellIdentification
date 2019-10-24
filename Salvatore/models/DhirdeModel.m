function [ impedance_spectrum_points ] = DhirdeModel( params, frequencies )
%DHIRDEMODEL Summary of this function goes here
%   Detailed explanation goes here
 Romega = params(1);
 R1 = params(2);
 R2 = params(3);
 Q1 = params(4);
 Q2 = params(5);
 phi1 = params(6);
 phi2 = params(7);
 Rd = params(8);
 tauD = params(9);
 L = params(10);
 
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE1 = Q1 .* (1i.* puls).^phi1;
 CPE2 = Q2 .* (1i.* puls).^phi2;
 
 ZRomega = Romega + 0.*puls;
 ZR1 = R1 + 0.*puls;
 ZR2 = R2 + 0.*puls;
 ZL = (1i*puls*L);
 Zcpe1 = 1./CPE1;
 Zcpe2 = 1./CPE2;

 Zpar1 = (Zcpe1.*ZR1)./(Zcpe1+ZR1);
 Zpar2 = (Zcpe2.*ZR2)./(Zcpe2+ZR2);
 Zpar3 = (ZL.*war)./(ZL+war);
 impedance_spectrum_points = ZRomega + Zpar1+ Zpar2+ Zpar3;
end

