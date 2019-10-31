function [ model, lb, ub ] = set_model_and_bound(name_model)

switch(name_model)
   case ('Fouquet')
        model = @FouquetModel;
        ub = [0.5   0.5  10    1   1  10 ];
   case ('FouquetRC')
        model = @Fouquet_RC_Model;
        ub = [0.5   0.5  10    1   1  10   1   10];
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
   case ('DhirdeC')
        model = @Dhirde_C_Model;
        ub = [1   1   1   10   1   1   10  10  10];
   case ('DhirdeCL')
        model = @DhirdeCL;
        ub = [1   1   1   10   1   1   10  10  10 10];
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