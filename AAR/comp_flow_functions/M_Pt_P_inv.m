function [ ptp ] = M_Pt_P_inv(M,gamma)
%M_Pt_P_INV generates the total pressure ratio from Mach number and gamma.
%   [ PTP ] = M_Pt_P_INV(M,GAMMA) is the function form.

g1 = (gamma-1)/2;
g2 = gamma/(gamma-1);

ptp = (1+g1*M^2)^g2;

end
