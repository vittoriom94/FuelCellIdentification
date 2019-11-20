function [params, model, result,f, info] = fitAndClassify(Z,freq)
% 1. fitta con fouquet
% 2. controlla il risultato
% 3. se non va bene, fitta con DhirdeL
% 4. controlla il risultato
% 5. se non va bene, fitta con DhirdeLWARL
% 6. ritorna il risultato
model = 'FouquetL'
[result,Zgen] = fitWithModel(Z,freq,model);
params = result.minparams;
% analizza
f = figure();
hold on
axis equal
plot(real(Z),-imag(Z),'Marker','o','MarkerSize',10);
plot(real(Zgen),-imag(Zgen),'Marker','.','MarkerSize',10);

[isGood, info(1,1)] = checkResult(Z,Zgen,freq);
if isGood == 1
    fprintf('\nok\n');
end

model = 'DhirdeL'
[result,Zgen] = fitWithModel(Z,freq,model);
params = result.minparams;
% analizza
plot(real(Zgen),-imag(Zgen),'Marker','.','MarkerSize',10);

[isGood, info(1,2)] = checkResult(Z,Zgen,freq);
if isGood == 1
    fprintf('\nok\n');
end

model = 'DhirdeLWARL'
[result,Zgen] = fitWithModel(Z,freq,model);
params = result.minparams;
plot(real(Zgen),-imag(Zgen),'Marker','.','MarkerSize',10);

[isGood, info(1,3)] = checkResult(Z,Zgen,freq);

legend('Sperimentale','FouquetL','DhirdeL','DhirdeLWARL');
end




function [result,Zgen] = fitWithModel(Z,freq,model)

amount = 100;

[ model, lowerBound, upperBound ] = set_model_and_bound(model);
start = generateUniformData(lowerBound, upperBound,amount) ;

result = struct('resid',[],'conf',[],'params',[]','minparams',[],'index',[],'outReason',[],'time',[],'initialResid',[],'factors',[]);
[result.resid,result.conf,result.params,result.minparams,result.index,result.outReason,result.time,result.initialResid] = ...
    fitMultiple(real(Z),imag(Z),...
    freq,lowerBound,upperBound,1,1,start,model);
Zgen = model(result.minparams,freq);

end


function [isGood,diff] = checkResult(Z,Zgen,freqs)

limit = 0.3;
% DhirdeL può fare 3 curve, ma in alcuni casi ne fa due perchè piazza i
% due CPE sulla prima singola curva

% calcolo l'errore da 10 hz in poi
indexHigh =  searchFrequency(freqs,10);
highError = getError(Z(1:indexHigh),Zgen(1:indexHigh));
% calcolo l'errore da 0 a 1 hz
indexLow =  searchFrequency(freqs,1);
lowError = getError(Z(indexLow:end),Zgen(indexLow:end));

diff = checkDifference(lowError,highError);
diff = lowError;
% 0.3 sembra buono
if lowError > limit
    isGood = 0;
else
    isGood = 1;
end


end

function error = getError(Zexp,Zgen)
maxR = max(abs(real(Zexp)));
maxI = max(abs(imag(Zexp)));
error = sqrt(sum( ((real(Zexp)-real(Zgen))/maxR).^2 + ((imag(Zexp)-imag(Zgen))/maxI).^2 ));
end
function diff = checkDifference(lowError,highError)
diff = lowError/highError;
end
function index = searchFrequency(freqs,num)

index = binarySearchInverted(freqs,num);


end
