function [ impedance_spectrum_points ] = DissociatedElectrodesModelsSimplified( params, frequencies )

 % SIMPLIFIED MODEL
 %           C                               CPECath
 % _________// __________             __________\\ __________
 % |        //          |    Romega  |          //           |
 % |                    |---/\/\/\___|                       |
 % |______/\/\/\________|            |__/\/\/\_____/warburg/_| 
 %        RctAno                       RctCath      cathode
 
 C = params(1);
 RctAno = params(2);
 Romega = params(3);
 Q = params(4);
 phi = params(5);
 RctCath = params(6);
 Rd = params(7);
 tauD = params(8);
 
 puls = 2 * pi .* frequencies;
 
 rad = sqrt(1i.*puls*tauD);
 war = Rd .* tanh(rad)./rad;

 CPE = Q .* (1i.* puls).^phi;
 
 ZRctAno = RctAno + 0.*puls;
 ZC = 1./(1j*puls*C);
 ZRomega = Romega + 0.*puls;
 Zcpe = 1./CPE;
 ZRctCath = RctCath + 0.*puls;

 ZparRC = (ZRctAno.*ZC)./(ZRctAno+ZC);
 Zpar = (ZRctCath+war).* Zcpe ./ (ZRctCath+war+Zcpe);
 impedance_spectrum_points = ZparRC + ZRomega + Zpar;

end

