function [ impedance_spectrum_points ] =  ZwarburgL( params, frequencies )
%ZWARBURG Summary of this function goes here
%   Detailed explanation goes here
Rd = params(1);
tauD = params(2);

Llf = params(3);

puls = 2 * pi .* frequencies;

rad = sqrt(1i.*puls*tauD);
war = Rd .* tanh(rad)./rad;
ZLlf = (1i*puls*Llf);
Zpar3 = (ZLlf.*war)./(ZLlf+war);
impedance_spectrum_points = Zpar3;
end

