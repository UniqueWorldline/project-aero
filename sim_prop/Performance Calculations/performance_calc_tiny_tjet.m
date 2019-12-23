function [ Isp,TSFC,ST ] = performance_calc_tiny_tjet( P0,v0,v9,f )

gc = 9.81;


ST = (1+f)*v9-v0;
Isp = ST/(f*gc);
TSFC = 1/(Isp*gc);


end

