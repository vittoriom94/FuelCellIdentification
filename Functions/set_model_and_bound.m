function [ model, lb, ub ,names] = set_model_and_bound(name_model)
names = {};
switch(name_model)
   case ('Fouquet')
        model = @FouquetModel;
        ub = [0.5   0.5  10    1   1  10 ];
        names = {'Romega','Rct','Q','phi','Rd','tauD'};
   case ('FouquetRC')
        model = @Fouquet_RC_Model;
        ub = [0.5   0.5  10    1   1  10   1   10];
        names = {'Romega','Rct','Q','phi','Rd','tauD','R','C'};
   case ('FouquetRCPE')
        model = @Fouquet_RCPE_Model;
        ub = [1   1  10    1   1  10   1   10  1];
   case ('FouquetRWar')
        model = @Fouquet_RWar_Model;
        ub = [1   1  10    1   1  10   1   1  10];
   case ('CompleteAnodeCathode')
        model = @DissociatedElectrodesModelsComplete;
        ub = [10   1   1   1   10   1   10     1   1   1   10];  
   case ('SimplifiedAnodeCathode')
        model = @DissociatedElectrodesModelsSimplified;
        ub = [10   1   1   10    1   1   1   10];
   case ('Dhirde')
        model = @DhirdeModel;
        ub = [1   1   1   10  10    1    1   1   10  10];
        names = {'Romega','Rct1','Rct2','Q1','Q2','phi1','phi2','Rd','tauD','L'};
   case ('DhirdeL')
        model = @DhirdeL;
        ub = [1   1   1   10  10    1    1   1   10  10  10];
        names = {'Romega','Rct1','Rct2','Q1','Q2','phi1','phi2','Rd','tauD','Lhf','Llf'};
   case ('DhirdeC')
        model = @Dhirde_C_Model;
        ub = [1   1   1   10   1   1   10  10  10];
        names = {'Romega','Rct1','Rct2','Q','phi','Rd','tauD','L','C'};
   case ('DhirdeCL')
        model = @DhirdeCL;
        ub = [1   1   1   10   1   1   10  10  10 10];
        names = {'Romega','Rct1','Rct2','Q','phi','Rd','tauD','Lhf','Llf','C'};
   case ('Asghari')
        model = @AsghariModel;
        ub = [1   1   1   10  10    1    1   10 ];
   case ('AsghariWar')
        model = @AsghariModel_War_Model;
        ub = [1   1   1   10  10    1    1   10   1  10 ];
   case ('R4C3')
        model = @R4C3Model;
        ub = [1   1   1   1   10   10   10 ];
   case ('LLFin')
        model = @LLFinModel;
        ub = [1   1   10   1   1   10   10 ];
   case ('LLFout')
        model = @LLFoutModel;
        ub = [1   1   10   1   1   10   10 ];
end

lb = zeros(1,length(ub));