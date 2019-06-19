function [ Arto ] = arto_calc(M,gamma)
%ARTO_CALC generates the area ratio from Mach number and gamma.
%   [ Arto ] = ARTO_CALC(M,GAMMA) is the function form.

g1 = 2/(gamma+1);
g2 = (gamma-1)/2;
g3 = (gamma+1)/(2*(gamma-1));

Arto = 1/M*(g1*(1+g2*M^2))^g3;

end