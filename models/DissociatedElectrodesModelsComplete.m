function [ impedance_spectrum_points ] = DissociatedElectrodesModelsComplete( params, frequencies )

 % COMPLETE MODEL
 
 %         CPEAno                             CPECath
 % _________\\ __________             __________\\ __________
 % |        //          |    Romega  |          //           |
 % |                    |---/\/\/\___|                       |
 % |_/\/\/\___/warburg/_|            |__/\/\/\_____/warburg/_| 
 %   RctAno     anode                   RctCath     cathode
 
 QAno = params(1);
 phiAno = params(2);
 RctAno = params(3);
 RdAno = params(4);
 tauDAno = params(5);
 
 Romega = params(6);
 
 QCath = params(7);
 phiCath = params(8);
 RctCath = params(9);
 RdCath = params(10);
 tauDCath = params(11);

 puls = 2 * pi .* frequencies;
 
 radAno = sqrt(1i.*puls*tauDAno);
 warAno = RdAno .* tanh(radAno)./radAno;
 
 radCath = sqrt(1i.*puls*tauDCath);
 warCath = RdCath .* tanh(radCath)./radCath;

 CPEAno = QAno .* (1i.* puls).^phiAno;
 CPECath = QCath .* (1i.* puls).^phiCath;
 
 ZcpeAno = 1./CPEAno;
 ZcpeCath = 1./CPECath;
 ZRctAno = RctAno + 0.*puls;
 ZRctCath = RctCath + 0.*puls;
 ZRomega = Romega + 0.*puls;

 ZparAno = (ZRctAno+warAno).* ZcpeAno ./ (ZRctAno+warAno+ZcpeAno);
 ZparCath = (ZRctCath+warCath).* ZcpeCath ./ (ZRctCath+warCath+ZcpeCath);
 impedance_spectrum_points = ZparAno + ZRomega + ZparCath;
 
end