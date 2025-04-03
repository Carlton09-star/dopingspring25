function [dif]=diffusionlength(temp)
D0=3.85;
Ea=3.66;
kb=8.62*10^(-5);
ctk=273.15;
D=D0*exp(-Ea/(kb*(temp+ctk)));
dif=2*sqrt(D*temp*60)*10^(4);