function y=CPE_CPE_W(a,f)
   % i e j non dovrebbero essere usati come parametri di ingresso 
   
   w =  2 * pi .* f;   
   L = a(1);
   Rs = a(2);
   Q1 = a(3);
   n1 = a(4);
   RP1 = a(5);
   Q2=a(6);
   n2=a(7);
   RP2=a(8);
   Aw=a(9);
   Cpe2 = 1./(Q2.*(1j*w).^n2);
   Cpe = 1./(Q1.*(1j*w).^n1);
   Zw = (Aw./sqrt(w))*(1-1j);
   
   Z = (1j*w)*L + Rs + 1./( 1./(1./(Q1*(1j*w).^n1)) + 1./RP1 ) +  1./( 1./(1./(Q2.*(1j*w).^n2)) + 1./RP2 ) + (Aw.*(1 - 1j))./sqrt(w);
    
   y = Z;
end

   
  
