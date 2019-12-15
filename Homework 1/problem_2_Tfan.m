%% Turbofan Model
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

% Fan bypass flow
BPR = 6;
FPR = 2;
Pt13 = FPR*Pt2;
Tt13 = FPR^((g-1)/g)*Tt2;

% Compressor
CPR = 30;
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

f = cp*(Tt4-Tt3)./(dhb-cp*Tt4);

% Turbine
Tt5 = Tt4 + (Tt2-Tt3)./(1+f) + BPR./(1+f).*(Tt2-Tt13);
Pt5 = (Tt5/Tt4).^(g/(g-1)).*Pt4;

% Nozzle
Tt6 = Tt5;
Pt7 = Pt5;
% v9  = sqrt( 2*cp.*Tt6 .*(1-(P0./Pt7).^(g/(g-1))) );
% v19 = sqrt( 2*cp.*Tt13*(1-(P0/Pt13).^(g/(g-1))) );

Taud = Tt2./Tt0;
Taub = Tt4./Tt3;
Taur = 1 + (g-1)/2.*M0.^2;
Tauc = Tt3Tt2;
Taut = Tt5./Tt4;
Tauf = Tt13./Tt2;

v9v0 = sqrt( (Taub.*(Taud.*Taur.*Tauc.*Taut - 1))./(Taur-1) );
v9 = v9v0.*v0;

v19v0 = sqrt( (Taur.*Taud.*Tauf-1)./(Taur-1));
v19 = v19v0.*v0;


%v9 = sqrt(2*cp*Tt6.*(1-(P0./Pt7).^(g/(g-1)) ));

% Thrust
ST = BPR/(BPR+1).*v19+(1+f)/(1+BPR).*v9 - v0;
Isp = ST.*(BPR+1)./(f.*gc);

% Find and save appropriate data

op_i = f>0 & Isp > 0 & imag(v9v0)==0; % Turbofan operating range

figure(1)
plot(M0(op_i),Hvector(op_i))
ax = gca;
ax.YRuler.Exponent = 0;

figure(2)
plot(M0(op_i),Isp(op_i))
xlabel('M')
ylabel('Isp')
ax = gca;
ax.YRuler.Exponent = 0;

tfan_M0 = M0(op_i);
tfan_Isp = Isp(op_i);
save('results_tfan','tfan_M0','tfan_Isp')


