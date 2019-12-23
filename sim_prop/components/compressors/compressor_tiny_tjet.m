function [ Tt3,Pt3 ] = compressor_tiny_tjet( Tt2,Pt2,g )

CPR = 10;
Tt3Tt2 = CPR^((g-1)/g);

Tt3 = Tt3Tt2.*Tt2;
Pt3 = CPR*Pt2;

end

