function fitOneRandom(p,init_p,FrequencyHz)


data = generateOneWithNoise(p,FrequencyHz,45);
% figure
% hold on
% plot(real(data),-imag(data));
lb = [0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0 ; 0.0];
ub = [0.2 ; 0.5 ; 1.0 ; 1.0 ; 0.5 ; 4.0];
fitter = ImpedanceCurveFitter();
fitter.loadData(real(data),-imag(data),FrequencyHz,'Normal condition');
fitter.fit(init_p,lb,ub,false);

% plot(fitter.GeneratedReal,-fitter.GeneratedImag);

%%
% grafico
minparams = fitter.Params;
param1 = {1,'Romega',lb(1),ub(1)};
param2 = {2,'Rct',lb(2),ub(2)};
param3 = {3,'Q',lb(3),ub(3)};
param4 = {4,'phi',lb(4),ub(4)};
param5 = {5,'Rd',lb(5),ub(5)};
param6 = {6,'tauD',lb(6),ub(6)};

manipulate({@(x,param) FouquetModel(param,x),FrequencyHz,minparams},{[0.025,0.25],[-0.01,0.05]},real(data),imag(data),param1,param2,param3,param4,param5,param6)


end