function [ Tt2,Pt2 ] = inlet_tiny_tjet( Tt0,Pt0,M0 )

Pt2Pt0 = mil_std_inlet(M0);
Pt2 = Pt2Pt0*Pt0;
Tt2 = Tt0;

end

