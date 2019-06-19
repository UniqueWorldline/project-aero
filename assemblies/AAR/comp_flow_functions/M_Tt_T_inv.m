function [ ttt ] = M_Tt_T_inv(M,gamma)
%M_Tt_T_INV generates total temperature ratio from Mach number and gamma.
%   [ ttt ] = M_Tt_T_INV(TTT,GAMMA) is the function form.

g1 = (gamma-1)/2;

ttt = 1 + g1*M^2;

end
