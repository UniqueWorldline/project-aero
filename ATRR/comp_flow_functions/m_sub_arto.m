function [M_sub] = m_sub_arto(arto,gamma,e)
%M_SUB_ARTO find the subsonic mach number of area ratio value.
%   [ M_SUB ] = M_SUB_ARTO( ARTO, GAMMA, E ) is the functional form.
%   e is the acceptable deviation of the iterated arto_i from the given
%   arto.

% Start iterating at mach equals 0
M = 0;

% Iterate until 
while true
    
    arto_i = arto_calc(M,gamma);
    
    if abs(arto-arto_i) > e && M < 1
        M = M + 0.0001;
        continue
    elseif M >= 1
        error(['Iterator failed to find mach number to desired precision. ',...
               'Iterator increments mach by 0.0001 mach each loop.'])
    else
        M_sub = M;
        return
    end
    
    
end

end

