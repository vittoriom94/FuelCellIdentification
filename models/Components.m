classdef Components < handle
    %COMPONENTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        VarsDhirde = 4;
        VarsDhirdeL = 5;
        VarsDhirdeCL = 5;
        
    end
    
    methods (Static)
        function values = getImpedances(modelName,params, frequencies)
            switch(modelName)
                case ('Dhirde')
                    [ ZRomega, Zpar1, Zpar2, Zpar3 ] = Components.Dhirde(params,frequencies);
                    values = [ZRomega Zpar1 Zpar2 Zpar3];
                case ('DhirdeL')
                    [ ZRomega , ZLhf , Zpar1, Zpar2, Zpar3 ] = Components.DhirdeL( params, frequencies );
                    values = [ZRomega ZLhf Zpar1 Zpar2 Zpar3];
                case ('DhirdeCL')
                    [ ZRomega,ZLhf , Zpar1, Zpar2, Zpar3 ] = Components.DhirdeCL( params, frequencies );
                    values = [ZRomega ZLhf Zpar1 Zpar2 Zpar3];
            end
            values = abs(values);
            
        end
        function [ ZRomega, Zpar1, Zpar2, Zpar3 ] = Dhirde( params, frequencies )
            
            %                   CPE 1              CPE 2
            %               _____\\______      _____\\_____       __/warburg/__
            %     Romega   |     //     |     |     //     |     |             |
            % ___/\/\/\____|            |-----|            |-----|             |
            %              |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
            %                   Rct 1              Rct 2                L
            
            Romega = params(1);
            Rct1 = params(2);
            Rct2 = params(3);
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
            ZRct1 = Rct1 + 0.*puls;
            ZRct2 = Rct2 + 0.*puls;
            ZL = (1i*puls*L);
            Zcpe1 = 1./CPE1;
            Zcpe2 = 1./CPE2;
            
            Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);
            Zpar2 = (Zcpe2.*ZRct2)./(Zcpe2+ZRct2);
            Zpar3 = (ZL.*war)./(ZL+war);
            %  impedance_spectrum_points = ZRomega + Zpar1+ Zpar2+ Zpar3;
        end
        
        function [ ZRomega , ZLhf , Zpar1, Zpar2, Zpar3 ] = DhirdeL( params, frequencies )
            
            %                                CPE 1              CPE 2
            %                            _____\\______      _____\\_____       __/warburg/__
            %    Romega      Lhf        |     //     |     |     //     |     |             |
            % ___/\/\/\_____OOOOO_______|            |-----|            |-----|             |
            %                           |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
            %                                Rct 1              Rct 2               Llf
            
            Romega = params(1);
            Rct1 = params(2);
            Rct2 = params(3);
            Q1 = params(4);
            Q2 = params(5);
            phi1 = params(6);
            phi2 = params(7);
            Rd = params(8);
            tauD = params(9);
            Lhf = params(10);
            Llf = params(11);
            
            puls = 2 * pi .* frequencies;
            
            rad = sqrt(1i.*puls*tauD);
            war = Rd .* tanh(rad)./rad;
            
            CPE1 = Q1 .* (1i.* puls).^phi1;
            CPE2 = Q2 .* (1i.* puls).^phi2;
            
            ZRomega = Romega + 0.*puls;
            ZRct1 = Rct1 + 0.*puls;
            ZRct2 = Rct2 + 0.*puls;
            ZLhf = (1i*puls*Lhf);
            ZLlf = (1i*puls*Llf);
            Zcpe1 = 1./CPE1;
            Zcpe2 = 1./CPE2;
            
            Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);
            Zpar2 = (Zcpe2.*ZRct2)./(Zcpe2+ZRct2);
            Zpar3 = (ZLlf.*war)./(ZLlf+war);
            %  impedance_spectrum_points = ZRomega + ZLhf + Zpar1+ Zpar2+ Zpar3;
        end
        function [ ZRomega,ZLhf , Zpar1, Zpar2, Zpar3 ] = DhirdeCL( params, frequencies )
            
            %                              CPE 1              C
            %                        ____\\______       _____//_____       __/warburg/__
            %    Romega     Lhf     |    //      |     |     //     |     |             |
            % ___/\/\/\____OOOOO____|            |-----|            |-----|             |
            %                       |___/\/\/\___|     |___/\/\/\___|     |____OOOOO____|
            %                            Rct 1               Rct 2              Llf
            
            Romega = params(1);
            Rct1 = params(2);
            Rct2 = params(3);
            Q = params(4);
            phi = params(5);
            Rd = params(6);
            tauD = params(7);
            Lhf = params(8);
            Llf = params(9);
            C = params(10);
            
            puls = 2 * pi .* frequencies;
            
            rad = sqrt(1i.*puls*tauD);
            war = Rd .* tanh(rad)./rad;
            
            CPE1 = Q .* (1i.* puls).^phi;
            
            ZRomega = Romega + 0.*puls;
            ZRct1 = Rct1 + 0.*puls;
            ZRct2 = Rct2 + 0.*puls;
            ZLhf = (1i*puls*Lhf);
            ZLlf = (1i*puls*Llf);
            Zcpe1 = 1./CPE1;
            ZC = 1./(1j*puls*C);
            
            Zpar1 = (Zcpe1.*ZRct1)./(Zcpe1+ZRct1);
            Zpar2 = (ZC.*ZRct2)./(ZC+ZRct2);
            Zpar3 = (ZLlf.*war)./(ZLlf+war);
            %  impedance_spectrum_points = ZRomega + ZLhf + Zpar1+ Zpar2+ Zpar3;
        end
        
        
        
    end
end

