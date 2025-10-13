function [dif]=diffusionlength(temp,time,sourcet)
if sourcet<3
D0=0.76;
Ea=3.46;
else
D0=3.85;
Ea=3.66;
end
kb=8.617*10^(-5);
ctk=273.15;
D=D0*exp(-Ea/(kb*(temp+ctk)));
dif=2*sqrt(D*time*60)*10^(4);
end
