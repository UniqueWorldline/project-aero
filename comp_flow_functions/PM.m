function [nu] = PM(M,g)
% PM(M) Calculate the Prandtl Meyer function at Mach number M
    g1 = (g+1)/(g-1);
    t1 = sqrt(g1) * atan( sqrt((M.^2-1)./g1 ));
    t2 = atan( sqrt(M.^2-1));
    nu = t1-t2;
end