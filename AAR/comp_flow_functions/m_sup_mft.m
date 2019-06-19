function [M_sup] = m_sup_mft(mft,gamma,e)
%M_SUP_MFT find the supersonic mach number of the mass flow function value.
%   [ M_SUP ] = M_SUP_MFT( MFT, GAMMA, ERROR ) is the functional form.
%   error is the acceptable deviation of the iterated mft_i from the given
%   mft.

% Start iterating at mach equals 0
M = 1;

% Iterate until 
while true
    
    mft_i = mft_calc(M,gamma);
    
    if abs(mft-mft_i) > e && M < 30
        M = M + 0.001;
        continue
    elseif M >= 30
        error(['Iterator failed to find mach number to desired precision. ',...
               'Iterator increments mach by 0.01 mach each loop.'])
    else
        M_sup = M;
        return
    end
    
    
end

end

