function [MD] = ns_mach(MU,g)
%NS_MACH returns the downstream mach number given the upstream mach number
g1 = (g-1)/2;
num = 1 + g1*MU^2;
den = g*MU^2-g1;

MD = sqrt(num/den);

end

