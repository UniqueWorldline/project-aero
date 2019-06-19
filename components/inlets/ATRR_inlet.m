function [Tt15, Pt15] = ATRR_inlet(mdot0, Pt0, Tt0, M15, M0)
%ATRR_INLET Summary of this function goes here
%   Detailed explanation goes here


% Assume inlet pressure ratio varies linearly
pi_d_1 = 0.96;
pi_d_2 = 0.669;
slope = (pi_d_2-pi_d_1)/(4-0.8);
intercept = pi_d_1 - slope*0.8;
pi_d = slope*M0 + intercept;

% Model flow across the inlet
Tt15 = Tt0; % isentropic
Pt15 = pi_d*Pt0; % 


end

