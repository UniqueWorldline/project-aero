function [M] = PM_inv(nu,g)
% PM(M) Calculate the Prandtl Meyer function at Mach number M
    Ms = 1.001:0.001:20;
    
    nus = PM(Ms,g);
    dnu = abs(nus-nu);
    
    M = Ms(dnu == min(dnu));
end