function [M_sup] = m_sup_arto(arto,gamma,e)
%M_SUP_ARTO find the supersonic mach number of area ratio value.
%   [ M_SUP ] = M_SUP_ARTO( ARTO, GAMMA, E ) is the functional form.
%   e is the acceptable deviation of the iterated arto_i from the given
%   arto.

% Start iterating at mach equals 0
M = 1;

% Iterate until 
while true
    
    arto_i = arto_calc(M,gamma);
    
    if abs(arto-arto_i) > e && M < 30
        M = M + 0.00001;
        continue
    elseif M >= 30
        error(['Iterator failed to find mach number to desired precision. ',...
               'Iterator increments mach by 0.0001 mach each loop.'])
    else
        M_sup = M;
        return
    end
    
    
end

end

