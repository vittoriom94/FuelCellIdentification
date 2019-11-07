classdef ShowData < handle
    %SHOWDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        function f = showByZ(graphTitle,names,Z)
            % names = column vector {'a';'b';'c'}
            co = [0 0 1;
                1 0 0;
                0 1 0;
                0.8500    0.3250    0.0980];
            set(groot,'defaultAxesColorOrder',co);
            if length(Z) >=2 && rem(length(Z),2)==0 && length(names)==length(Z)/2
                f = figure();
                title(graphTitle)
                hold on
                grid on
                axis equal
                xlabel('Re(Z) [\Omega]');
                ylabel('-Im(Z) [\Omega]');
                
                plot(Z{1},-Z{2},'- k',...
                    'Marker','.','MarkerSize',14);
                
                %                 xticks(floor(Z{1}(1,1)):0.02:ceil(Z{1}(48,1)));
                %                 yticks(-0.1:0.02:0.2);
                %                 xticklabels(xticks*1000);
                %                 yticklabels(yticks*1000);
                %                 a = get(gca,'XTickLabel');
                %                 set(gca,'XTickLabel',a,'fontsize',7);
                
                %                 a = get(gca,'YTickLabel');
                %                 set(gca,'YTickLabel',a,'fontsize',7);
                
                for i=3:2:length(Z)
                    plot(Z{i},-Z{i+1},...
                        'Marker','.','MarkerSize',10);
                end
                hold off
                legend(names);
            end
        end
        
        function f = showByParams(model,frequencies,title,names,params)
            
            for i=1:length(params)
                imp = model(params{i},frequencies);
                Z{2*i-1} = real(imp);
                Z{2*i} = imag(imp);
            end
            f = ShowData.showByZ(title,names,Z);
            
        end
        
        function f = showByCell(fullData,cellNumber,names,fittings)
            % si considera fouquetModel di default
            % fittings = [1 ,3 4] : stampa fitting 1, fitting 3 e fitting 4
            if nargin <4
                numberOfFittings = length(fullData(cellNumber,3:end));
                fittings = 1:numberOfFittings;
            end
            Z = cell(1,2+2*length(fittings));
            Z{1} = -fullData{cellNumber,1}.realPartOfImpedance;
            Z{2} = -fullData{cellNumber,1}.imagPartOfImpedance;
            freq = fullData{cellNumber,1}.FrequencyHz;
            for i=1:length(fittings)
                params = fullData{cellNumber,fittings(i)+2}.minparams;
                Zi = FouquetModel(params,freq);
                Z{i*2+1} = real(Zi);
                Z{i*2+2} = imag(Zi);
            end
            ShowData.showByZ('Fittings',names,Z);
            
        end
        
        function f = showByZFrequency(names,Z,freqs)
            % names = column vector {'a';'b';'c'}
            
            set(groot,'defaultAxesColorOrder','remove')
            if length(Z) >=2 && rem(length(Z),2)==0 && length(names)==length(Z)/2
                f = figure();
                subplot(2,1,1)
                hold on
                grid on
                set(gca, 'XScale', 'log');
                %                 axis equal
                xlabel('Hz')
                ylabel('Re(Z) [\Omega]');
                plot(freqs{1},Z{1},'- k',...
                    'Marker','+','MarkerSize',7);
                
                subplot(2,1,2)
                hold on
                grid on
                set(gca, 'XScale', 'log');
                %                 axis equal
                xlabel('Hz')
                ylabel('-Im(Z) [\Omega]');
                
                plot(freqs{1},-Z{2},'- k',...
                    'Marker','+','MarkerSize',7);
                
                %                 xticks(floor(Z{1}(1,1)):0.02:ceil(Z{1}(48,1)));
                %                 yticks(-0.1:0.02:0.2);
                %                 xticklabels(xticks*1000);
                %                 yticklabels(yticks*1000);
                %                 a = get(gca,'XTickLabel');
                %                 set(gca,'XTickLabel',a,'fontsize',7);
                
                %                 a = get(gca,'YTickLabel');
                %                 set(gca,'YTickLabel',a,'fontsize',7);
                
                for i=3:2:length(Z)
                    subplot(2,1,1)
                    plot(freqs{(i+1)/2},Z{i},...
                        'Marker','.','MarkerSize',12);
                    subplot(2,1,2)
                    plot(freqs{(i+1)/2},-Z{i+1},...
                        'Marker','.','MarkerSize',10);
                end
                hold off
                subplot(2,1,1)
                legend(names);
            end
        end
        
        function f = showPage(Z,params,models,freq,cellName,otherData)
            % stampa z sperimentale: no linea solo cerchi
            % cicla su params e models per stamparli
            f = figure();
            set(f,'units','pix','position',[900 100 600 900])
            
            ax = axes(f);
            set(ax,'units','pix','position',[70 340 490 520])
%             title(graphTitle)
            hold on
            grid on
            axis equal
            xlabel('Re(Z) [\Omega]');
            ylabel('-Im(Z) [\Omega]');
            title(replace(cellName,'_','\_'));
            baseX = 10;
            baseY = 1;
            lengthX = 200;
            lengthY = 280;
            spacingY = 10;
            spacingX = 10;
            
            for i=1:length(params)
               [model,~,~,names] = set_model_and_bound(models{i});
               imp = model(params{i},freq);
               plot(real(imp),-imag(imp),'Marker','.','MarkerSize',12);
               fs = sprintf('%s\n\n',models{i});
               for j=1:length(names)
                   fs = [fs names{j} ' = ' sprintf('%.4g;\n',params{i}(j))]; 
               end 
               fs  = [fs sprintf('\nRMSE = %.4g\nErmse = %.4g',RMSE(Z,imp),RMSE(Z,imp)/max(abs(Z)))];
               uicontrol(f,'style','text','Units','pixels','String',fs,...
                'Position',[baseX baseY lengthX lengthY],'FontSize',10,...
                'HorizontalAlignment','left');
               baseX = baseX + lengthX + spacingX;

            end
            plot(ax,real(Z),-imag(Z),'k',...
                'Marker','o','MarkerSize',8,'LineStyle','none');
            legend([models 'Sperimentale']);
            %il testo posso metterlo da 1 a 600 per la x e da 1 a 300 per
            %la y



        end
    end
end

