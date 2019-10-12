function generateAndShow(params,freq,Model)
    Z = Model(params,freq);
    plot(real(Z),-imag(Z));
end