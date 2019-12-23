%MATLAB SCRIPT FOR QUESTION 2
close all
clear, clc
% List givens
q=1500;       %Single dynamic corridor, psf
CPRtjet=10;     CPRtfan=30;
FPR=2;          BPR=6;
HB=18500;     %Delta H_B for kerosene, for f<<1, h=1=HB
Cp=0.3;       %BTU/(lbm * degF)
Tt4=2600+460; %Turbine Inlet Temp, 2600F convert to Rankine
Tt8=3500+460; %A/B temp or Ramjet Temp, 3500F convert to Rankine
Ttscram=4000+460; %Scramjet burner Temp, 4000F convert to Rankine
Pc=3000;      %Rocket Chamber Pressure, psi
g=32.2;       %ft/s^2
 
%call MATLAB atmosphere script, build atmosphere in 100' increments to
%144,200 feet. At that altitude 1500 psf is orbital velocity. No sense
%going any higher.
[temp,press,rho,Hgeopvector]=atmosphere(0:100:144200,0);
 
% Mach = v/a
% u0 = sqrt(2*q./rho)
% a = sqrt(gamma*R*T)
R=1716.55;  %ft^2/(sec^2degR)
gamma=1.4;
a  = sqrt(gamma*R.*temp);
u0 = sqrt(2*q./rho);
M0 = u0./a;     %Mach indexed to altitude values for constant q
 
% Build Engine Relationships
%% Freestream Recovery (all engines)
T0=temp;                            %atm static temp
Tt0=T0.*(1+((gamma-1)/2).*M0.^2);   %Total Temperature
TAUr=Tt0./T0;                       %Recovery Temp Ratio
P0=press;                           %atm static pressure
PIr=(TAUr).^(gamma/(gamma-1));      %Isentropic relationship
 
Pt0=PIr.*P0;                        %Total Pressure
 
%% Diffuser (all engines)
% For diffuser starting at station 0 and ending ending at turbofan inlet at 
% station 19. Without fan,set FPR=1 to 'skip' this station and go to
% station 2 for compressor.
 
Pt19=ones(size(M0));    % "pre-allocate for speed"
 
% Mil Std 5008B for diffuser recovery
i=0;
while i<length(M0)
i=i+1;
    if M0(i)<1
    Pt19(i)=Pt0(i);
    elseif M0(i)<5
    Pt19(i)=Pt0(i).*(1-0.075.*(M0(i)-1)^1.35);
    else
    Pt19(i)=Pt0(i).*(800./(M0(i).^4+935));
    end
end
 
PId=Pt19./Pt0;                      %Diffuser Pressure Ratio
Tt19=Tt0.*(PId).^((gamma-1)/gamma); %Isentropic Relationship
TAUd=Tt19./Tt0;                     %Diffuser Temp Ratio
 
%% Turbofan
PIf=FPR;                            %Fan Pressure Ratio
Pt2=FPR.*Pt19;                      %Total Pressure at fan exit
Tt2=Tt19.*(FPR)^((gamma-1)/gamma);  %Total Temp at fan exit/ comp inlet
TAUf=Tt2./Tt19;                     %Fan Temp Ratio
 
%% Compressor (Turbofan)
PIc=CPRtfan;                       %Compressor Pressure Ratio with fan
Pt3=Pt2.*CPRtfan;                  %Total Pressure at compressor exit
TAUc=(CPRtfan)^((gamma-1)/gamma);  %Compressor Temp ratio with fan
Tt3=Tt2.*TAUc;                     %Total Temp at compressor exit
%% Burner  (Turbofan)
PIb=1; Pt4=Pt3;         % Ideal burner, no total pressure change
TAUb=Tt4./Tt3;          % Non-isentropic temperature relation
 
%% Turbine (Turbofan)
f=(Cp/HB)*(Tt4-Tt3);
Tt5 = Tt4 + (Tt2-Tt3)./(1+f) + BPR.*(Tt19-Tt2)./(1+f);
TAUt=Tt5./Tt4;
PIt=(TAUt).^(gamma/(gamma-1));
Pt5=PIt.*Pt4;
%% Afterburner
% Not in this turbofan
%% Nozzle
% Ideal nozzle, PIn=TAUn=1, so can use turbine exit relations to simplify
%% Velocity Ratio  (Turbofan)
u9u0=sqrt( (TAUb.*  (TAUr.*TAUd.*TAUf.*TAUc.*TAUt - 1)  )./(TAUr-1));
% u9/u0 is velocity ratio in core
 
u9fu0=sqrt( (TAUr.*TAUd.*TAUf-1) ./(TAUr-1));
% u9f/u0 is velocity ratio in fan
 
u9f=u9fu0.*u0;              %Fan exit velocity
 
%Force=m_dot.*(u9-u0);          Thrust is mass flow times velocity diff.
%Force/m_dot = u9-u0            Specific Thrust of core is delta v
 
FStfan=(u0./(1+BPR)).*((u9u0-1)+BPR.*(u9fu0-1));
% When velocities equal, no thrust! If u9<u0, net drag!
MF = find( FStfan <0, 1);    % Finds when specific thrust first <0
Mf = find( f      <0, 1);    % Finds when fuel flow first becomes <0
                             % Fuel flow drops to keep turbine in limits
 
%Stop plot when engine is net drag (MF reached) or no fuel (Mf reached)
Limit= min([MF,Mf])-1;        % -1 to keep positive
 
ISP_tfan= (u0./((f).*g)) .* ((u9u0-1) + BPR.*(u9fu0-1));
figure(1)
plot(M0(1:Limit),ISP_tfan(1:Limit))
title('ISP vs Mach (IDEAL)')
xlabel('Mach'),ylabel('ISP (s)')
hold on
 
 
 
%% Turbojet (overwrite variables, replot on figure 1
% Freestream recovery and diffuser are same; use same variables.
% No fan section
%% Delete Turbofan (Turbojet)
Pt2=Pt19; Tt2=Tt19;
 
%% Compressor (Turbojet)
PIc=CPRtjet;                       %Compressor Pressure Ratio with fan
Pt3=Pt2.*CPRtjet;                  %Total Pressure at compressor exit
TAUc=(CPRtjet)^((gamma-1)/gamma);  %Compressor Temp ratio with fan
Tt3=Tt2.*TAUc;                     %Total Temp at compressor exit
%% Burner (Turbojet)
PIb=1; Pt4=Pt3;         % Ideal burner, no total pressure change
TAUb=Tt4./Tt3;          % Non-isentropic temperature relation
%% Turbine (Turbojet)
f=(Cp/HB)*(Tt4-Tt3);
Tt5 = Tt4 + (Tt2-Tt3)./(1+f);
TAUt=Tt5./Tt4;
PIt=(TAUt).^(gamma/(gamma-1));
Pt5=PIt.*Pt4;
%% Afterburner
% Not in this turbojet
%% Nozzle
% Ideal nozzle, PIn=TAUn=1, so can use turbine exit relations to simplify
%% Velocity Ratio  (Turbojet)
u9u0=sqrt( (TAUb.*  (TAUr.*TAUd.*TAUc.*TAUt - 1)  )./(TAUr-1));
% u9/u0 is velocity ratio in core
 
FStjet=(u0).*(u9u0-1);
% When velocities equal, no thrust! If u9<u0, net drag!
MF = find( FStjet <0, 1);    % Finds when specific thrust first <0
Mf = find( f      <0, 1);    % Finds when fuel flow first becomes <0
                             % Fuel flow drops to keep turbine in limits
                             
%Stop plot when engine is net drag (MF reached) or no fuel (Mf reached)
Limit= min([MF,Mf]) -1;      % -1 to keep positive
 
%still figure(1)
ISP_tjet= FStjet./(f.*g);
plot(M0(1:Limit),ISP_tjet(1:Limit))
 
%% Turbojet with Afterburner (overwrite variables, replot on figure 1
% All parts through turbine are same between A/B and non-A/B tjet
% Work balance of turbine remains the same, A/B doesn't drive t or c
%% Afterburner
%Starts with turbine exit at station 5, fuel addition at station 7, and 
%ends with station 8 at nozzle throat.
%Ratios are therefore station 8 to station 5
Pt8=Pt5;                %Constant pressure combustion
PIAB=1;
% For nonAB only one energy addition,      T9/T0 = TAUb 
% For AB since there's now two energy additions, T9/T0 = (TAUb * TAUAB)
% Assume Tt8 is constand and is maximum temp for A/B, given above
TAUAB=Tt8./Tt5;
%T9/T0=TAUb.*TAUAB
%% Fuel Air Ratio for AB
%TAU_lambda of AB= TauLAB=Tt8./T0;
TauLAB=Tt8./T0;
%From CH5 derivations and balancing enthalpy across AB,
fAB=(Cp.*T0./HB).*(TauLAB-TAUr);
 
%u9/u0 = (M9/M0) * sqrt(T9/T0)
%In derivation, (M9/M0) came from relating pressure ratios. PIAB=1, so this
%is the same. Only change is addition of TAUAB into numerator.
 
%For Tjet,
%u9u0=sqrt( (TAUb.*        (TAUr.*TAUd.*TAUc.*TAUt - 1))./(TAUr-1));
%For A/B Tjet,
 u9u0=sqrt( (TAUb.*TAUAB.* (TAUr.*TAUd.*TAUc.*TAUt - 1))./(TAUr-1));
% u9/u0 is velocity ratio in core
 
u9=u9u0.*u0;                %Core Exit velocity
 
FStjetAB=(u0).*(u9u0-1);
% When velocities equal, no thrust! If u9<u0, net drag!
MF = find( FStjetAB <0, 1);    % Finds when specific thrust first <0
Mf = find( fAB      <0, 1);    % Finds when fuel flow first becomes <0
                             % Fuel flow drops to keep turbine in limits
                             
%Stop plot when engine is net drag (MF reached) or no fuel (Mf reached)
Limit= min([MF,Mf]) -1;      % -1 to keep positive
 
%still figure(1)
ISP_tjetAB= FStjetAB./(fAB.*g);
plot(M0(1:Limit),ISP_tjetAB(1:Limit))
 
 
 
%% Ramjet
%Ramjet is Ram Air Method Jet, which means ram air itself provides the
%compression. Therefore no compressor, and no turbine to drive the
%compressor. Also, no burner to drive the turbine, so it's just an
%afterburner in a specially-shaped pipe. 
 
%Basically diffuser, afterburner, and nozzle.
 
%% Delete Machinery
%Assuming ideal conditions, freestream, recovery, and diffuser are the same
%as above. Delete compressor, burner and turbine so that station 5 is the
%same as station 2
Pt3=Pt2; Tt3=Tt2;               %Delete compressor
Pt4=Pt3; Tt4=Tt3;               %Delete burner that drives turbine
Pt5=Pt4; Tt5=Tt4;               %Delete turbine
 
%% Ramjet burner
Pt8=Pt5;                        % IDEAL, Constant pressure combustion
%Tt8 is given as max ramjet temp, same as afterburner temp
%with same limitation, essentially a turbojet with no machinery losses, and
%no Tt4 limitation
TAUram=Tt8./Tt5;
 
%Seeing pattern with other systems, velocity ratio is same as turbojet, but
%only one energy addition in ramjet, and no compressor/turbine ratios
u9u0=sqrt( (TAUram.* (TAUr.*TAUd - 1))./(TAUr-1));
 
 
FSram=(u0).*(u9u0-1);       %Specific Thrust
 
fram=(Cp/HB)*(Tt8-Tt5);     % Fuel air ratio across burner section like 
                            % turbojet, but moved to ramjet burner
 
% When velocities equal, no thrust! If u9<u0, net drag!
MF = find( FSram <0, 1);    % Finds when specific thrust first <0
Mf = find( fram  <0, 1);    % Finds when fuel flow first becomes <0
                            % Fuel flow drops to keep burner in limits
 
%Start plot at minimum Ramjet start speed, at M0=1.7
M0ram=find(M0>=1.7,1);
 
%Stop plot when engine is net drag (MF reached) or no fuel (Mf reached)
Limit= min([MF,Mf]) -1;      % -1 to keep positive
 
%still figure(1)
ISP_ram= FSram./(fram.*g);
plot(M0(M0ram:Limit),ISP_ram(M0ram:Limit))
 
%% Scramjet
%Scramjet is Supersonic Combustion Ram Air Method Jet, which means ram air 
%itself provides the compression. However, the air is still supersonic 
%by the time it reaches the burner, and oblique shocks exist inside the 
%burner. To accurately model requires Rayleigh flow, and knowledge of Mach
%numbers througout the engine. Basically needs a kinetic energy balance.
 
% Per Dr. Heister's email response, this will simply be modeled as a 
% "faster" ramjet because Mach numbers inside the engine aren't given.
% Highly inaccurate, but it's what we have to go on for now.
%% Scramjet burner
Pt8=Pt5;            % IDEAL, Constant pressure combustion
                    % Absolutely untrue in scramjet, but disregard for HW         
%Ttscram is given as max scramjet temp, is higher than A/B or ramjet
TAUscram=Ttscram./Tt5;
fscram=(Cp/HB)*(Ttscram-Tt5); % Fuel air ratio across scramjet burner
                              %Tt5 is same for Ramjet & Scramjet, so with
                              %higher Tt8 in scram, higher fuel burn which
                              %results in lower Isp at first.
 
%Seeing pattern with other systems, velocity ratio is same as turbojet, but
%only one energy addition in ramjet, and no compressor/turbine ratios
u9u0=sqrt( (TAUscram.* (TAUr.*TAUd - 1))./(TAUr-1));
 
FSscram=(u0).*(u9u0-1);       %Specific Thrust
 
 
 
% When velocities equal, no thrust! If u9<u0, net drag!
MF = find( FSscram <0, 1);    % Finds when specific thrust first <0
Mf = find( fscram  <0, 1);    % Finds when fuel flow first becomes <0
                            % Fuel flow drops to keep burner in limits
 
%Scramjet starts at M0=3.5
M0scram=find(M0>=3.5,1);
%Stop plot when engine is net drag (MF reached) or no fuel (Mf reached)
Limits= min([MF,Mf]) -1;      % -1 to keep positive
 
%still figure(1)
ISP_scram= FSscram./(fscram.*g);
plot(M0(M0scram:Limits),ISP_scram(M0scram:Limits))
 
%% Rocket
%Run CEA at a number of altitudes to determine Isp of Rocket to Mach...
%One CEA parameter is Pc/Pe, or chamber pressure to exit pressure. I'll
%choose ten exit pressures along the Mach corridor from Mach 1 to Mach 7. 
Mhi=find(M0>7,1);           %Element where Mach first exceeds 7
Mr=round(linspace(1,Mhi,10));  %Builds evenly spaced element numbers
 
Pe=ones(size(Mr));          %Pre-allocation
Mrocket=ones(size(Mr));     %Pre-allocation
i=0;
while i<length(Mr)
i=i+1;
    Pe(i)=press(Mr(i));        %Convert psf to psi
    Mrocket(i)=M0(Mr(i));
end
 
% Now have evenly space Pe (in psi) indexed to Mach from 1-7.
 
PcPe=Pc./Pe;                     % Used to find ISP from CEA website
 
Ispms=[ 893.4, 1253.9, 1545.4, 1795.9, 2025.4, 2226.5, 2404.8,...
    2562.4, 2704.8, 2831.4 ];    %copied from word document
Isp=Ispms./9.8;                  %converted from m/s to s
 
plot(Mrocket,Isp)
xlim([1,7])
legend('Turbofan','Turbojet','Afterburning Turbojet',...
    'Ramjet (M0max=6.48)','Scramjet (M0max=6.90)','Rocket')
