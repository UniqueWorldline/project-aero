function [ M ] = M_Pt_P(ptp,gamma)
%M_Pt_P generates Mach number from total pressure ratio and gamma.
%   [ M ] = M_Pt_P(PTP,GAMMA) is the function form.

g1 = 2/(gamma-1);
g2 = (gamma-1)/gamma;

M = (g1*(ptp^g2-1))^.5;

end

