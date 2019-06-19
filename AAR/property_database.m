clear gas, clc

%% Standard Atmosphere (SI)
atm = readtable('std_atm.csv');

%% Compressible Flow Table
compflow = readtable('comp_flow_g_1_4.csv');

%% Universal Constants

% Universal gas constant
RR = 3.406*1000; % % lb ft/(kmol*R)

% Molar masses
M_DryAir = 1.9850755; % slugs/kmol (28.97 kg/kmol)
O2.MM  = 2.1927; % slugs/kmol (32)
N2.MM  = 1.92984701; % slugs/kmol (28.164)
H2.MM  = 0.137044; % slugs/kmol (2)


%% Air Struct

% Mass fraction of air constituents: air.[species].m_frac
O2.m_frac = 0.232;
N2.m_frac = 0.768;

% Mixture properties: air.prop
prop.gamma     = 1.4;
prop.R_dryair  = RR/M_DryAir; % lb ft / (slug*R)
prop.cp_dryair = prop.R_dryair*prop.gamma/(prop.gamma-1);

% Compose the struct
gas.O2   = O2;
gas.N2   = N2;
gas.H2   = H2;
gas.prop = prop;
gas.RR   = RR;



