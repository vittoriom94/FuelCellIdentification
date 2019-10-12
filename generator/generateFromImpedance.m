function [outputArg1,outputArg2] = generateFromImpedance(Z,amount)

Zr = real(Z);
Zi = imag(Z);
Ztot = cell(amount,1);

weights = [zeros(1,12) linspace(0,1,36)];
noise = weights'.*0.05.*(rand(48,2)-0.5);

data = (Zr+Zr.*noise(:,1))+1i*(Zi+Zi.*noise(:,2));

for i=1:amount
    
    
end



end

% rumore lineare
% rumore pesato
% rumore awgn
% moltiplica tutto per un fattore
% ruota rotate(h,[0 0 1],1), h è la linea fatta con plot
% poi faccio x=get(h,'Xdata') y=get(h,'Ydata')
