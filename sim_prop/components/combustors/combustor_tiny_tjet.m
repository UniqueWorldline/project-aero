function [ Tt4,Pt4,f,Cpm ] = combustor_tiny_tjet( Pt3,Tt3,phi,fuel )

property_database();

% Fuel properties
[ LHV,Cpf,FAs ] = fuel_selector( fuel );

% Air and mixed Cp
Cpa = gas.air.CPdryair.metric;
Cpm = (Cpa+Cpf)/2;
f = phi*FAs;

% Energy Equation
Tt4 = (Cpa*Tt3 + f*LHV)/( (1 + f)*Cpm );

% Constant Pressure Combustion
Pt4 = Pt3;

end

