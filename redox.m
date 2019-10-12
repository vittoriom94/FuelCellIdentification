clc
close all
clearvars

%% Parametri %%
folder = dir("../dati redox flow/S*.xlsx");

% 0: Mostra i grafici e salva su file
% 1: Mostra i grafici solamente
% 2: Salva su file solamente
display = 1; 

grafici_colonna = 3; % numero di grafici da visualizzare per colonna, 3 consigliato
grafici_riga = 4; % numero di grafici da visualizzare per riga


%% %%%%%%%%% %%


files_data = load_data(folder);
save("../dati redox flow/redox_data.mat",'files_data');
print_all(files_data,grafici_colonna,grafici_riga,display);
%print_one(files_data,3,1);



% passare il file dei dati, il numero della cella e il numero del file
function print_one(files_data,num_cell,file)
    Z = files_data{file,2};
    Z_real = real(Z(:,num_cell));
    Z_imag = -imag(Z(:,num_cell));
    plot(Z_real,Z_imag);
    title(files_data{file,3}(1,num_cell))
end

%rows: numero di righe per ogni figure, columns: numero di colonne per ogni
%figure.
%Si consiglia columns = 3, in modo che ogni colonna rappresenta la stessa
%cella a corrente diverse.
% display_mode:
% 0: Mostra i grafici e salva su file
% 1: Mostra i grafici solamente
% 2: Salva su file solamente
function print_all(files_data,rows,columns,display_mode)
    images = pwd+ "\images\";
    mkdir('images');
    rows_counter = 1;
    columns_counter = 1;
    for c = 1:size(files_data{1,2},2)
        for n = 1:size(files_data,1)
       
          %freq = files_data{n,1};
          Z = files_data{n,2};
          Z_real = real(Z(:,c));
          Z_imag = -imag(Z(:,c));
          if display_mode ~= 1
              hidden = figure('visible','off');
              plot(Z_real,Z_imag);
              title(files_data{n,3}(1,c))
              saveas(hidden,images+replace(files_data{n,3}(1,c)," ","_"),'png');
              close(hidden);
          end
          if display_mode ~= 2
              if rows_counter == 1 && columns_counter == 1
                  figure('units','normalized','outerposition',[0 0 1 1])
              end
              subplot(rows,columns,(rows_counter-1)*columns+columns_counter);
              plot(Z_real,Z_imag);
              title(files_data{n,3}(1,c))
              rows_counter=rows_counter+1;

              if rows_counter > rows
                  rows_counter = 1;
                  columns_counter=columns_counter+1;
              end
              if columns_counter > columns
                  columns_counter = 1;
              end
          end
          
       end
    end

end

function files_data = load_data(folder)

    % ogni riga ha frequenza | impedenza | nome cella
    files_data = cell(size(folder,1),3);


    % colonne: 1-2 -> ignora, 3 -> frequenza, poi considera ogni 4 per cella,
    % ultima colonna -> ignora
    for n = 1:size(folder,1)

        T = datastore(folder(n).folder+"\"+folder(n).name);
        T.Sheets = 2;
        data = read(T);
        f_redox = data{:,3};
        number_of_cells = (size(data,2)-4)/4;
        Z_redox = zeros(size(f_redox,1),number_of_cells);
        cell_names = strings(1,21);
        for i = 0:number_of_cells-1
           real_part = data{:,(i*4)+4};
           imag_part = data{:,(i*4)+5};
           Z_redox(:,i+1) = real_part+1i*imag_part;
           cell_names(1,i+1)=get_name(folder(n).name,data.Properties.VariableNames((i*4)+4));
        end

        %f_redox: colonna di frequenze
        %Z_redox: ogni colonna rappresenta l'impedenza di una batteria
        files_data{n,1} = f_redox;
        files_data{n,2} = Z_redox;
        files_data{n,3} = cell_names;
    end

end

function name = get_name(file_name,cell_name)
    split_result = split(file_name, ", ");
    current = split_result{3,1};
    split_result = split(cell_name{1,1},"_Re");
    redox_name = split_result{1,1};
    name = replace(redox_name,"_"," ") + " " + current;
    
    
end