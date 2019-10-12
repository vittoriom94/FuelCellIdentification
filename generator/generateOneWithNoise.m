function [data, clean] = generateOneWithNoise(Model,params,x,noiseLevel,noiseType)
    % noiseType:
    % 0: awgn
    % 1: linear
    % 2: incremented
 
clean = Model(params,x);
switch noiseType
    case 0
        data = awgn(clean,noiseLevel,'measured');
    case 1
        % 0.1 standard per noiselevel
        noise = noiseLevel*(rand(length(clean),2)-0.5);
        data = (real(clean)+real(clean).*noise(:,1))+1i*(imag(clean)+imag(clean).*noise(:,2));
        
    case 2
        sp = [zeros(1,length(clean)/2) linspace(0.2,1.2,length(clean)/2 )];
        noise = sp'.*noiseLevel.*(rand(length(clean),2)-0.5);
        data = (real(clean)+real(clean).*noise(:,1))+1i*(imag(clean)+imag(clean).*noise(:,2));
        
    otherwise
        data = awgn(clean,noiseLevel,'measured');
        wgn(1,11);


end