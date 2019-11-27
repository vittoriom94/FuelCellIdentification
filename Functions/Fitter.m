classdef Fitter < handle
    %FITTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function dataFitAndClass = fit(this,chosenImages,amounts)
            f_ev = [0.1 0.5 1 5 10 100];
            dataFitAndClass = struct('models',[],'params',[],'errors',[],'variations',[],'choice',[],'times',[],'convergences',[]);
            for i=1:length(chosenImages)
                Z = chosenImages(i).data.realPartOfImpedance +1i*chosenImages(i).data.imagPartOfImpedance;
                freq = chosenImages(i).data.FrequencyHz;
                indexes = this.calcolaFrequenze(freq,f_ev);
                
                f = this.creaFigura(Z,indexes);
                [params, models,errors,variations,choice,time,convergences] = this.inizializza();
                
                
                % fai fitting
                model = 'DhirdeSimple';
                amount = amounts(1);
                [result,Zgen,convergence,xerrorLow,yerrorLow,totalerrorLow,oldParams,directionsLow] = this.fitCompleto(model,amount,freq,Z,indexes,[],[]);
                if mean(totalerrorLow) < 0.01 || length(unique(directionsLow)) == 1
                    fprintf('Concluso\n');
                    choice = 1;
                end
                params{1,1} = result.minparams;
                models{1,1} = model;
                errors{1,1} = mean(xerrorLow);
                errors{1,2} = mean(yerrorLow);
                errors{1,3} = mean(totalerrorLow);
                time{1,1} = min(cell2mat(result.time));
                time{1,2} = max(cell2mat(result.time));
                time{1,3} = mean(cell2mat(result.time));
                convergences{1,1} = convergence;
                variations{1,1} = 0;
                
                model = 'DhirdeL';
                amount = amounts(2);
                [result,Zgen,convergence,xerrorLow,yerrorLow,totalerrorLow,oldParams,directionsLow] = this.fitCompleto(model,amount,freq,Z,indexes,oldParams,[1 2 3 4 8]);
                firstVariation = this.checkVariation(oldParams,result.minparams);
                if mean(totalerrorLow) < 0.01 || length(unique(directionsLow)) == 1
                    fprintf('Concluso\n');
                    if choice == 0
                        choice = 2;
                    end
                end
                params{2,1} = result.minparams;
                models{2,2} = model;
                errors{2,1} = mean(xerrorLow);
                errors{2,2} = mean(yerrorLow);
                errors{2,3} = mean(totalerrorLow);
                time{2,1} = min(cell2mat(result.time));
                time{2,2} = max(cell2mat(result.time));
                time{2,3} = mean(cell2mat(result.time));
                convergences{2,1} = convergence;
                variations{2,1} = firstVariation;
                
                
                
                model = 'DhirdeLWARL';
                amount = amounts(3);
                [result,Zgen,convergence,xerrorLow,yerrorLow,totalerrorLow,oldParams,directionsLow] = this.fitCompleto(model,amount,freq,Z,indexes,oldParams,[1 2 3 4 8 9 10 11]);
                secondVariation = this.checkVariation(oldParams,result.minparams);
                if choice == 0
                    choice = 3;
                end
                params{3,1} = result.minparams;
                models{3,1} = model;
                errors{3,1} = mean(xerrorLow);
                errors{3,2} = mean(yerrorLow);
                errors{3,3} = mean(totalerrorLow);
                time{3,1} = min(cell2mat(result.time));
                time{3,2} = max(cell2mat(result.time));
                time{3,3} = mean(cell2mat(result.time));
                convergences{3,1} = convergence;
                variations{3,1} = secondVariation;
                
                dataFitAndClass(i).models = models;
                dataFitAndClass(i).params = params;
                dataFitAndClass(i).variations = variations;
                dataFitAndClass(i).choice = choice;
                dataFitAndClass(i).errors = errors;
                dataFitAndClass(i).times = time;
                dataFitAndClass(i).convergences = convergences;
                
                close(f);
            end
            
            
        end
        function indexes = calcolaFrequenze(this,freq,f_ev)
            indexes = zeros(1,length(f_ev));
            for j=1:length(indexes)
                indexes(j) = binarySearchInverted(freq,f_ev(j));
            end
            
        end
        function f = creaFigura(this,Z,indexes)
            f = figure();
            hold on
            grid on
            axis equal
            xlabel('Re(Z) [\Omega]');
            ylabel('-Im(Z) [\Omega]');
            plot(real(Z),-imag(Z),'- k',...
                'Marker','.','MarkerSize',14);
            for j=1:length(indexes)
                plot(real(Z(indexes(j))),-imag(Z(indexes(j))),'LineStyle','none','Marker','o','MarkerSize',12);
            end
        end
        function [params,models,errors,variations,choice,time,convergence] = inizializza(this)
            params = cell(3,1);
            models= cell(3,1);
            errors = cell(3,3);
            variations = cell(3,1);
            time = cell(3,3);
            convergence = cell(3,1);
            choice = 0;
        end
        function [result,Zgen,convergence,xerrorLow,yerrorLow,totalerrorLow,oldParams,directionsLow] = fitCompleto(this,model,amount,freq,Z,indexes,previousParams,fixed)
            
            [result,Zgen] = this.fitWithModel(Z,freq,model,amount,previousParams, fixed);
            convergence = ImpedanceGroups.getConvergence(result,model,freq);
            % stampa retta
            plot(real(Zgen),-imag(Zgen),'- r',...
                'Marker','.','MarkerSize',14);
            % calcola errore a bassa frequenza
            directionsLow = zeros(length(Zgen)-1-indexes(3),1);
            distancesLow = directionsLow;
            xerrorLow = directionsLow;
            yerrorLow = directionsLow;
            totalerrorLow = directionsLow;
            for j=indexes(3):length(Zgen)-1
                ind = j+1-indexes(3);
                [directionsLow(ind), distancesLow(ind), xerrorLow(ind), yerrorLow(ind), totalerrorLow(ind)] = this.checkDirectionAndDistance(Z,Zgen,j);
            end
            % calcola errore ad alta frequenza
            directionsHigh = zeros(indexes(6),1);
            distancesHigh = directionsHigh;
            xerrorHigh = directionsHigh;
            yerrorHigh = directionsHigh;
            totalerrorHigh = directionsHigh;
            for j=1:indexes(6)
                ind = j;
                [directionsHigh(ind), distancesHigh(ind), xerrorHigh(ind), yerrorHigh(ind), totalerrorHigh(ind)] = this.checkDirectionAndDistance(Z,Zgen,j);
            end
            
            fprintf('\nDHIRDE SEMPLICE: xerror medio: %.4f, yerror medio: %.4f, total error medio: %.4f\n', mean(xerrorLow),mean(yerrorLow),mean(totalerrorLow));
            fprintf('Errore alta freq: xerror medio: %.4f, yerror medio: %.4f, total error medio: %.4f\n', mean(xerrorHigh),mean(yerrorHigh),mean(totalerrorHigh));
            oldParams = result.minparams;
            
            
        end
        
        
        function variation = checkVariation(this,oldP,newP)
            variation = (newP(1:length(oldP))-oldP)./oldP;
        end
        function [direction,distance,xerror,yerror,totalerror] = checkDirectionAndDistance(this,Z,Zgen,index)
            
            maxDist = max(abs(Zgen));
            
            x1 =  real(Zgen(index));
            y1 =  -imag(Zgen(index));
            
            x2 = real(Zgen(index+1));
            y2 =  -imag(Zgen(index+1));
            plot([x1 x2],[y1 y2],'g','Marker','x','MarkerSize',12);
            
            m = (y2-y1)/(x2-x1);
            q = y2-(y2-y1)*x2/(x2-x1);
            
            ymisurata = -imag(Z(index));
            ymassima = m*real(Z(index)) + q;
            
            direction = not(xor(ymisurata > ymassima, m < 0));
            
            distance = abs(ymisurata - (m*real(Z(index)) + q))/sqrt(1+m^2);
            
            xerror = abs((x1-real(Z(index)))/real(Z(index)));
            yerror = abs((y1-ymisurata)/ymisurata);
            
            distmis = sqrt(real(Z(index))^2 + imag(Z(index))^2);
            distgen = sqrt(real(Zgen(index))^2 + imag(Zgen(index))^2);
            totalerror = abs(distmis-distgen)/maxDist;
            
        end
        function [result,Zgen] = fitWithModel(this,Z,freq,model,amount,previousParams,fixed)
            
            
            
            [ model, lowerBound, upperBound ] = set_model_and_bound(model);
            start = generateUniformData(lowerBound, upperBound,amount) ;
            if(~isempty(previousParams))
                for i=1:length(fixed)
                    index = fixed(i);
                    start(:,index) = previousParams(index);
                    %         start(:,1:length(previousParams)) = repmat(previousParams,size(start,1),1);
                end
            end
            result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
            [result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
                fitMultiple(real(Z),imag(Z),...
                freq,lowerBound,upperBound,1,1,start,model);
            Zgen = model(result.minparams,freq);
        end
    end
end
