function [output] = ATRR_inlet(mdot0, Pt0, Tt0, M1, M15, g)
%ATRR_INLET Simulates the inlet of the ATRR assembly
%   [OUTPUT] = ATRR_INLET(MDOT0,PT0, TT0, M0, M15, G) 
%   OUTPUT contains [TT15, T15, PT15, P15, MDOT15, MFT15, A15, U15].

% Load the property database
run('property_database')

% Assume inlet pressure ratio varies linearly
pi_d_1 = 0.96;
pi_d_2 = 0.669;
slope = (pi_d_2-pi_d_1)/(4-0.8);
intercept = pi_d_1 - slope*0.8;
pi_d = slope*M1 + intercept;

% Model flow across the inlet
mdot15 = mdot0;
Tt15 = Tt0; % isentropic
Pt15 = pi_d*Pt0; 
P15 = Pt15/M_Pt_P_inv(M15,g);
mft15 = mft_calc(M15,g);
A15 = mdot15*sqrt(gas.prop.R_dryair*Tt15)/(Pt15*mft15);
T15 = Tt15/M_Tt_T_inv(M15,g);
u15 = M15*sqrt(g*gas.prop.R_dryair*T15);

output = [Tt15, T15, Pt15, P15, mdot15, mft15, A15, u15];

end

