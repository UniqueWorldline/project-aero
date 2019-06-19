function [ M ] = M_Tt_T(ttt,gamma)
%M_Tt_T generates Mach number from total temperature ratio and gamma.
%   [ M ] = M_Tt_T(TTT,GAMMA) is the function form.

g1 = 2/(gamma-1);

M = (g1*(ttt-1))^.5;

end

