function [M_sub] = m_sub_mft(mft,gamma,tol)
%M_SUB_MFT find the subsonic mach number of the mass flow function value.
%   [ M_SUB ] = M_SUB_MFT( MFT, GAMMA, ERROR ) is the functional form.
%   error is the acceptable deviation of the iterated mft_i from the given
%   mft.

a = 0;
b = 1;
f = @(M) mft_calc(M,gamma)-mft;


% Iterate until 
while b-a > tol
    M = a + (b-a)/2;
    
    if f(M)*f(a) > 0
        a = M;
    else
        b = M;
    end 
end

if f(M) > 0.1 || f(M) < -0.1
    warning(['Regula falsi is not accurate to within 10^-1. ',...
             'Check the answer manually.'])
         
    M = -1;
end

M_sub = M;

end

