 function [ Isp,TSFC,ST ] = assembly_tiny_tjet( Tt0,Pt0,M0,a0,phi )

property_database();

g_air = gas.air.gamma;
fuel = "std_a";

P0 = Pt0/M_Pt_P_inv(M0,g_air);
v0 = M0*a0;

[ Tt2,Pt2 ] = inlet_tiny_tjet( Tt0,Pt0,M0 );
[ Tt3,Pt3 ] = compressor_tiny_tjet( Tt2,Pt2,g_air );
[ Tt4,Pt4,f,Cpm ] = combustor_tiny_tjet( Pt3,Tt3,phi,fuel );
[ Tt5,Pt5 ] = turbine_tiny_tjet( Tt2,Tt3,Tt4,Pt4,g_air,f );
[ v9 ] = nozzle_tiny_tjet( Tt5,Pt5,P0,v0,Cpm,g_air );

[ Isp,TSFC,ST ] = performance_calc_tiny_tjet( P0,v0,v9,f );
[ A0,A2,A3,A4,A5 ] = sizing_tiny_tjet(Tt0,Pt0,Tt2,Pt2,Tt3,Pt3,Tt4,Pt4,Tt5,Pt5,f);

end

