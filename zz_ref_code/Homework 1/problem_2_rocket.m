%% Rocket
clear, clc, close all

% Input Processing
g = 1.4; % gamma
gc = 32.17; % ft/s^2
R1 = 53.34; % Btu/(lbm F)
R  = 1715.91; % lbf ft/(slug R)

% Flight corridor
q = 1500; % 1500 psf corridor

Hvector = linspace(0, 80000,5);
GeometricFlag = 1;
[T0,P0,rho0,Hgeopvector] = atmosphere(Hvector,GeometricFlag);

v0 = sqrt(2*q./rho0);
a0 = sqrt(g*R*T0);
M0 = v0./a0;

Tt0T0 = 1 + ((g-1)/2).*M0.^2;
Pt0P0 = Tt0T0.^(g/(g-1));

Tt0 = Tt0T0.*T0;
Pt0 = Pt0P0.*P0;

% Chamber
Pc = 3000*144;

% CEA Input
P0/144
PcP0 = Pc./P0

% CEA Output
Isp = [ 315.7084608 329.6330275 343.3741081 355.4740061 365.4943935 ];

plot(M0,Isp)

Isp_rocket = Isp;
M0_rocket = M0;

save('results_rocket','Isp_rocket','M0_rocket')