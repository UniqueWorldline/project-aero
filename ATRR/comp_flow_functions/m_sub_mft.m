function [M_sub] = m_sub_mft(mft,gamma,e)
%M_SUB_MFT find the subsonic mach number of the mass flow function value.
%   [ M_SUB ] = M_SUB_MFT( MFT, GAMMA, ERROR ) is the functional form.
%   error is the acceptable deviation of the iterated mft_i from the given
%   mft.

% Start iterating at mach equals 0
M = 0;

% Iterate until 
while true
    
    mft_i = mft_calc(M,gamma);
    
    if abs(mft-mft_i) > e && M < 1
        M = M + 0.001;
        continue
    elseif M >= 1
        error(['Iterator failed to find mach number to desired precision. ',...
               'Iterator increments mach by 0.01 mach each loop.'])
    else
        M_sub = M;
        return
    end
    
    
end

end

