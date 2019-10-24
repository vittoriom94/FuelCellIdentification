function [ model, numvar, lb, ub ] = set_model_and_bound(name_model)

if (strcmp(name_model,'Fouquet') == 1 ) 
    model = @FouquetModel;
    numvar = 6;
    lb = [0   0   0   -1   0   0];
    ub = [1   1  10    1   1  10];
elseif (strcmp(name_model,'Dhirde') == 1 )
    model = @DhirdeModel;
    numvar = 10;
    lb = [0   0   0    0   0   -1   -1   0   0   0];
    ub = [1   1   1   10  10    1    1   1   10  1];
elseif (strcmp(name_model,'Asghari') == 1 )
    model = @AsghariModel;
    numvar = 8;
    lb = [0   0   0    0   0   -1   -1   0 ];
    ub = [1   1   1   10  10    1    1   1 ];
elseif (strcmp(name_model,'R4C3') == 1 )
    model = @R4C3Model;
    numvar = 7;
    lb = [0   0   0   0    0    0    0 ];
    ub = [1   1   1   1   10   10   10 ];
elseif (strcmp(name_model,'FouquetRC') == 1 )
    model = @Fouquet_RC_Model;
    numvar = 8;
    lb = [0   0   0   -1   0   0   0   0];
    ub = [1   1  10    1   1  10   1   1];
elseif (strcmp(name_model,'CompleteAnodeCathode') == 1 )
    model = @DissociatedElectrodesModelsComplete;
    numvar = 11;
    lb = [0   -1   0   0   0    0    0    -1   0   0    0];
    ub = [10   1   1   1   10   1   10     1   1   1   10];
elseif (strcmp(name_model,'SimplifiedAnodeCathode') == 1 )
    model = @DissociatedElectrodesModelsSimplified;
    numvar = 8;
    lb = [0    0   0   0    -1   0   0   0 ];
    ub = [10   1   1   10    1   1   1   10];
end 

end