function [ Tt5,Pt5 ] = turbine_tiny_tjet( Tt2,Tt3,Tt4,Pt4,g,f )

Tt5 = (Tt2-Tt3)./(1+f) + Tt4;
Pt5 = (Tt5./Tt4).^(g/(g-1)).*Pt4;

end

