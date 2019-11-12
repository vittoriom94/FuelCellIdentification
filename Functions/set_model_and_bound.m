function [ model, lb, ub ] = set_model_and_bound(name_model)

switch(name_model)
   case ('Fouquet')
        model = @FouquetModel;
        ub = [0.5   0.5  10    1   1  10 ];
        lb = zeros(1,length(ub));
   case ('FouquetRC')
        model = @Fouquet_RC_Model;
        ub = [0.5   0.5  10    1   1  10   1   10];
        lb = zeros(1,length(ub));
   case ('FouquetRCPE')
        model = @FouquetRCPE;
        ub = [0.5   0.5  10    1   1  10   1   10  1];
        lb = [0   0   0   0   0   0.1   0   0   0];
   case ('FouquetRCPEL')
        model = @FouquetRCPEL;
        ub = [0.5   0.5  10    1   1   10    1   10   1   10];
        lb = [0     0    0     0   0   0.1   0   0    0   0];
   case ('FouquetRWar')
        model = @Fouquet_RWar_Model;
        ub = [1   1  10    1   1  10   1   1  10];
        lb = zeros(1,length(ub));
   case ('CompleteAnodeCathode')
        model = @DissociatedElectrodesModelsComplete;
        ub = [10   1   1   1   10   1   10     1   1   1   10];  
        lb = zeros(1,length(ub));
   case ('SimplifiedAnodeCathode')
        model = @DissociatedElectrodesModelsSimplified;
        ub = [10   1   1   10    1   1   1   10];
        lb = zeros(1,length(ub));
   case ('Dhirde')
        model = @Dhirde;
        ub = [1   1   1   10  10    1    1   1   10  10];
        lb = [0   0   0   0   0   0   0   0   0.1   0];
   case ('DhirdeL')
        model = @DhirdeL;
        ub = [1   1   1   10  10    1    1   1   10  10  10];
        lb = [0   0   0   0   0   0   0   0   0.1   0  0];
   case ('DhirdeLWARL')
        model = @DhirdeLWARL;
        ub = [1   1   1   10  10    1    1   1   10  10  10  1  10  10];
        lb = [0   0   0   0   0   0   0   0   0.1   0  0   0   0   0];
   case ('DhirdeLCPE')
        model = @DhirdeLCPE;
        ub = [1   1   1   10  10    1    1   1   10  10  10  10  1  1];
        lb = [0   0   0   0   0   0   0   0   0.1   0  0   0   0   0];
   case ('DhirdeLCPEWARL')
        model = @DhirdeLCPEWARL;
        ub = [1   1   1   10  10    1    1   1   10  10  10  10  1  1  1   10  10];
        lb = [0   0   0   0   0   0   0   0   0.1   0  0   0   0   0   0   0   0];
   case ('DhirdeLCPECPE')
        model = @DhirdeLCPECPE;
        ub = [1   1   1   10  10    1    1   1   10  10  10  10  1  1  10  1  1];
        lb = [0   0   0   0   0   0   0   0   0.1   0  0   0   0   0   0   0   0];
   case ('DhirdeC')
        model = @Dhirde_C_Model;
        ub = [1   1   1   10   1   1   10  10  10];
        lb = zeros(1,length(ub));
   case ('DhirdeCL')
        model = @DhirdeCL;
        ub = [1   1   1   10   1   1   10  10  10 10];
        lb = [0   0   0   0   0   0   0.1   0   0   0];
   case ('Asghari')
        model = @AsghariModel;
        ub = [1   1   1   10  10    1    1   10 ];
        lb = zeros(1,length(ub));
   case ('AsghariWar')
        model = @AsghariModel_War_Model;
        ub = [1   1   1   10  10    1    1   10   1  10 ];
        lb = zeros(1,length(ub));
   case ('R4C3')
        model = @R4C3Model;
        ub = [1   1   1   1   10   10   10 ];
        lb = zeros(1,length(ub));
   case ('LLFin')
        model = @LLFinModel;
        ub = [1   1   10   1   1   10   10 ];
        lb = zeros(1,length(ub));
   case ('LLFout')
        model = @LLFoutModel;
        ub = [1   1   10   1   1   10   10 ];
        lb = zeros(1,length(ub));
end

%lb = zeros(1,length(ub));