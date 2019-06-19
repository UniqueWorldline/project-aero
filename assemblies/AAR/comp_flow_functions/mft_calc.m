function [ mft ] = mft_calc(M,gamma)
%MFT_CALC generates mass flow function from Mach number and gamma.
%   [ MFT ] = MFT_CALC(M,GAMMA) is the function form.

g1 = (gamma-1)/2;
g2 = -(gamma+1)/(2*(gamma-1));

mft = sqrt(gamma)*M*(1+g1*M^2)^g2;

end