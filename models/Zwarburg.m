function [ impedance_spectrum_points ] =  Zwarburg( params, frequencies )
%ZWARBURG Summary of this function goes here
%   Detailed explanation goes here
Rd = params(1);
tauD = params(2);


puls = 2 * pi .* frequencies;

rad = sqrt(1i.*puls*tauD);
war = Rd .* tanh(rad)./rad;


impedance_spectrum_points = war;
end

