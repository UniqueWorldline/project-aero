%% Ramjet Model
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
Pt3Pt0 = mil_std_inlet(M0);
Pt3 = Pt3Pt0.*Pt0;
Tt3 = Tt0;

% Burner
dhb1 = 18500; % Btu/lbm
dhb = dhb1*25037; % lbf ft/slug R
cp1 = 0.3; % BTU/(lbm F)
cp  = cp1*25037; % ft^2/s^2

Tt4 = 3500 + 460.67; % R
Pt4 = Pt3;

f = cp*(Tt4-Tt3)./(dhb-cp*Tt4);

% Nozzle
Taud = Tt3./Tt0;
Taub = Tt4./Tt3;
Taur = 1 + (g-1)/2.*M0.^2;

v9v0 = sqrt( (Taub.*(Taud.*Taur - 1))./(Taur-1) );
v9 = v9v0.*v0;

%v9 = sqrt(2*cp*Tt6.*(1-(P0./Pt7).^(g/(g-1)) ));

% Thrust
ST = (1+f).*v9 - v0;
Isp = ST./(f.*gc);

op_i = f>0 & Isp > 0 & M0>1.7;

plot(M0(op_i),Isp(op_i))
xlabel('M')
ylabel('Isp')


M0_ram = M0(op_i);
Isp_ram = Isp(op_i);
save('results_ram','M0_ram','Isp_ram')