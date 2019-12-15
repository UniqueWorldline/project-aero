%% Turbojet Model
clear, clc, close all
% Input Processing
g = 1.4; % gamma
gc = 32.17; % ft/s^2
R1 = 53.34; % Btu/(lbm F)
R  = 1715.91; % lbf ft/(slug R)

% Flight corridor
q = 1500; % 1500 psf corridor

Hvector = linspace(0, 120000,1000);
GeometricFlag = 1;
[T0,P0,rho0,Hgeopvector] = atmosphere(Hvector,GeometricFlag);

v0 = sqrt(2*q./rho0);
a0 = sqrt(g*R*T0);
M0 = v0./a0;

Tt0T0 = 1 + ((g-1)/2).*M0.^2;
Pt0P0 = Tt0T0.^(g/(g-1));

Tt0 = Tt0T0.*T0;
Pt0 = Pt0P0.*P0;

% Inlet
Pt2Pt0 = mil_std_inlet(M0);
Pt2 = Pt2Pt0.*Pt0;
Tt2 = Tt0;

% Compressor
CPR = 10;
Tt3Tt2 = CPR^((g-1)/g);

Tt3 = Tt3Tt2.*Tt2;
Pt3 = CPR*Pt2;

% Burner
dhb1 = 18500; % Btu/lbm
dhb = dhb1*25037; % lbf ft/slug R
cp1 = 0.3; % BTU/(lbm F)
cp  = cp1*25037; % ft^2/s^2

Pt4 = Pt3;
Tt4 = 2600 + 460.67; % R

f = cp*(Tt4-Tt3)/(dhb-cp*Tt4);
%f = cp*(Tt4-Tt3)/dhb; % introduces 5% error

% Turbine
Tt5 = (Tt2-Tt3)./(1+f) + Tt4;
Pt5 = (Tt5./Tt4).^(g/(g-1)).*Pt4;

% Nozzle
Tt6 = Tt5;
Pt7 = Pt5;
Taud = Tt2./Tt0;
Taub = Tt4./Tt3;
Taur = 1 + (g-1)/2.*M0.^2;
Tauc = Tt3Tt2;
Taut = Tt5./Tt4;

v9v0 = sqrt( (Taub.*(Taud.*Taur.*Tauc.*Taut - 1))./(Taur-1) );
v9 = v9v0.*v0;

% v9 = sqrt(2*cp*Tt6.*(1-(P0./Pt7).^(g/(g-1)) ));

% Thrust
ST = (1+f).*v0.*(v9v0 - 1);
Isp = ST./(f.*gc);

% Find and save appropriate data
op_i = ST>0 & f>0; % Turbojet operating range
min_i = find(min(Isp(op_i)) == Isp(op_i));
op_i(min_i:end) = [];

figure(1)
plot(M0(op_i),Hvector(op_i))
ax = gca;
ax.YRuler.Exponent = 0;
xlabel('M')
ylabel('h')

figure(2)
plot(M0(op_i),Isp(op_i))
xlabel('M')
ylabel('Isp [s]')
ax = gca;
ax.YRuler.Exponent = 0;

tjet_M0 = M0(op_i);
tjet_Isp = Isp(op_i);
Hvector_dpc = Hvector;
M0_dpc = M0;
save('results_tjet','tjet_M0','tjet_Isp')
save('dpc','Hvector_dpc','M0_dpc')
