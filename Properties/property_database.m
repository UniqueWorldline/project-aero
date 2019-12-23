clear gas

%% Standard Atmosphere (SI)
atm_si = readtable('std_atm_si.csv');
atm_eng = readtable('std_atm_english.csv');

%% Compressible Flow Table
compflow = readtable('comp_flow_g_1_4.csv');

%% Universal Constants

% Universal gas constant
RR.dyer = 49710; % lb ft/(kmol(slug/kg) R)  (Divide by kg/kmol for specific)
RR.eng = 3406.217; % lb ft/(kmol R)
RR.metric = 8314; % J/(kmol K)

% Molar masses
MMdryair.eng = 1.9850755; % slugs/kmol (28.97 kg/kmol)
MMdryair.metric = 28.97; % kg/kmol
O2.MM.eng  = 2.1927; % slugs/kmol (32)
N2.MM.eng  = 1.92984701; % slugs/kmol (28.164)
H2.MM.eng  = 0.137044; % slugs/kmol (2)


%% Air Struct

% Mass fraction of air constituents: air.[species].m_frac
O2.m_frac = 0.232;
N2.m_frac = 0.768;

% Mixture properties: gas.air
air.gamma     = 1.4;
air.Rdryair.eng  = RR.eng/MMdryair.eng; % lb ft / (slug*R)
air.Rdryair.metric = RR.metric/MMdryair.metric;
air.CPdryair.eng = air.Rdryair.eng*air.gamma/(air.gamma-1);
air.CPdryair.metric = air.Rdryair.metric*air.gamma/(air.gamma-1);

% Compose the struct
gas.O2   = O2;
gas.N2   = N2;
gas.H2   = H2;
gas.air = air;
gas.RR   = RR;


clearvars H2 MMdryair N2 O2 RR air
