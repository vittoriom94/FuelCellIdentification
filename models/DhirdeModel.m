function [ impedance_spectrum_points ] = DhirdeModel( Romega, R1, R2, Q1, Q2, phi1, phi2, Rd, tauD, L, frequencies )
%DHIRDEMODEL Summary of this function goes here
%   Detailed explanation goes here

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

