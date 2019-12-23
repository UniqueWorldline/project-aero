%% Air Turbo Rocket Ramjet
% Aerospace Propulsion Final Project - Part 2

clear, clc, close all
run('startup')

phis = [1 2 10];

% Properties Overide
%phis = 2;

%% Initialize Constants

% Load the standard atmosphere
atm = readtable('std_atm.csv');

% gamma
g = 1.4;

% Universal gas constant
RR = 3.406*1000; % % lb ft/(kmol*R)

% Molar masses
M_DryAir = 1.9850755; % slugs/kmol (28.97 kg/kmol)
O2.MM  = 2.1927; % slugs/kmol (32)
N2.MM  = 1.92984701; % slugs/kmol (28.164)
H2.MM  = 0.137044; % slugs/kmol (2)

% Mass fraction of air constituents:
O2.m_frac = 0.232;
N2.m_frac = 0.768;

% Mixture properties: air.prop
R_dryair  = RR/M_DryAir; % lb ft / (slug*R)
cp_dryair = R_dryair*g/(g-1);


%% Run the Simulation

% Iterator Variable
PIs_fan = 1.1:0.1:4;

% Properties Overide
% PIs_fan = 2;

% DEBUG OVERRIDE
% PIs_fan = 2;

% Turbomachinery Efficiencies
etaF = 0.95; % Fan
etaT = 0.90; % Turbine
etaS = 0.99; % Shaft


% Specify flight condition values
% Launch (flight condition 1)
h1 = 30000; % 30000 ft
M1 = 0.8;
pid = 0.96; % Diffuser (inlet) recovery
Cd = 0.2;
FN_g = 4000; % Required thrust


% Freestream conditions (station 0) (flight condition 1)
Ttrto = M_Tt_T_inv(M1,g);
Ptrto = M_Pt_P_inv(M1,g);

Tt0 = Ttrto * interp1(atm.h,atm.t,h1);
Pt0 = Ptrto * interp1(atm.h,atm.P,h1);

T0  = Tt0/Ttrto;
P0  = Pt0/Ptrto;

u0 = M1*sqrt(g*R_dryair*T0);
rho0 = P0/(R_dryair*T0);

mft0 = mft_calc(M1,g);


% Begin Iteration
for m = 1:length(phis)
    for n = 1:length(PIs_fan)
        
        % Select specific phi and PIfan
        phi = phis(m);
        pif = PIs_fan(n);
        
        % Inlet (Pressure Recovery and Isenthalpic Assumption)
        Pt12 = pid*Pt0;
        Tt12 = Tt0;
        
        % Station 13 (Fan pressure rise)
        Pt13 = pif*Pt12;
        
        % Station 15 (Isentropic flow)
        Pt15 = Pt13;
        M15  = 0.2; % Given
        P15  = Pt15/M_Pt_P_inv(M15,g);
        
        % Station X
        Mx  = 1; % Given
        Px  = P15;
        Ptx = Px*M_Pt_P_inv(Mx,g);
        mftx = mft_calc(Mx,g); % Choaked throat
        
        % Station C (The Combustion Problem)
        Ptc = 2E5; % psf total chamber pressure
        
        % Turbine
        pit  = Ptx/Ptc; % Turbine pressure ratio (Ptx = Pt5 by isentropic flow)
        g1   = (g-1)/g;
        taut = 1 - etaT*(1-pit^g1); % Turbine temperature ratio
        
        % Mass Fractions
        yO = 32/(4*phi+32);
        yH = 4*phi/(4*phi+32);
        yN = 0;
        
        % Compute Ttc.
        CpH = g*(RR/H2.MM)/(g-1);
        CpO = g*(RR/O2.MM)/(g-1);
        
        T_inject = 540;
        hc = (yH*CpH*T_inject + yO*CpO*T_inject);
        Ttc = Ttbrn_yHyOyNhi(yH,yO,yN,hc,g);
        
        MWT = MWT_yHyOyN(yH,yO,yN);
        R_mix = 49710/MWT;               % CL
        Cp_mix = R_mix*g/(g-1);
        
        
        % Calculate Specific Work
        wt = Cp_mix*Ttc*(1-taut);
        
        % Find A0 by regula falsi
        A0_l = 0.0;  % m^2
        A0_h = 1000; % m^2
        A0_g = (A0_l+A0_h)/2;
        
        % DEBUG OVERIDE
        % A0_g = 2.11;
        
        exit = false;
        while exit == false
            
            % Rubber Inlet
            A1 = A0_g;
            
            % Fan Airflow
            mdot0  = Pt0*A0_g*mft0 / sqrt(R_dryair*Tt0);
            tauf   = (-1+pif^g1)/etaF + 1; % Fan Temperature Ratio
            Tt13   = tauf*Tt12;
            WdotF  = mdot0*cp_dryair*(Tt13-Tt12); % Fan Power
            
            % Turbine
            mdott = WdotF/(etaS*wt); % Turbine mass flow
            Tt5 = taut*Ttc;
            
            % Station X
            mdotx = mdott;
            Ttx   = Tt5;
            Ax    = mdotx*sqrt(Ttx*R_mix)/(Ptx*mftx);
            Tx    = Ttx/M_Tt_T_inv(Mx,g);
            ux    = Mx*sqrt(g*R_mix*Tx);
            Ix    = mdotx*ux+Px*Ax;
            
            % Station 15
            mdot15 = mdot0 - mdott;
            mft15  = mft_calc(M15,g);
            Tt15   = Tt13;
            T15    = Tt15/M_Tt_T_inv(M15,g);
            A15    = mdot15*sqrt(R_dryair*Tt15)/(mft15*Pt15);
            u15    = M15 * sqrt(g*R_dryair*T15);
            I15    = mdot15*u15 + P15*A15;
            
            % Mass Flow Accounting
            mdotO = yO*mdotx;
            mdotH = yH*mdotx;
            
            % Mixer Flow
            Amixer = A15 + Ax;
            mdot_mixer = mdotx + mdot15;
            Imixer = Ix + I15;
            hi = (mdotH*CpH*T_inject    + mdotO*CpO*T_inject...
               +  mdot15*cp_dryair*Tt12 - mdott*wt*(1-etaS))/mdot_mixer;
            
            % Station 7 (Mixer Combustion Propagation)
            % Find Cp7
            mdot7   = mdot_mixer;
            
            yO15    = O2.m_frac;
            yN15    = N2.m_frac;
            
            mdotO15 = mdot15*yO15;
            mdotN15 = mdot15*yN15;
            
            yO7     = (mdotO15 + mdotO)/mdot7; % combine the oxygen species
            yN7     = mdotN15/mdot7;           % only comes from air
            yH7     = mdotH/mdot7;             % only comes from fuel
            
            MWT = MWT_yHyOyN(yH7,yO7,yN7);
            R7  = 49710/MWT; % CL
            Cp7 = R7*g/(g-1);
            
            % Find Tt7
            Tt7 = Ttbrn_yHyOyNhi(yH7,yO7,yN7,hi,g);
            
            ht7  = Cp7*Tt7;
            I7   = Imixer;
            mfi7 = ht7*(mdot7/I7)^2;
            M7   = m_sub_mfi(mfi7,g);
            A7   = Amixer;
            
            T7 = Tt7/M_Tt_T_inv(M7,g);
            u7   = M7*sqrt(g*R7*T7);
            rho7 = mdot7/(u7*Amixer);
            P7   = rho7*R7*T7;
            Pt7  = P7*M_Pt_P_inv(M7,g);
            
            % Station 8 Properties
            M8  = 1; % Given
            R8  = R7;
            A8  = A7*mft_calc(M7,g)/mft_calc(M8,g);
            Tt8 = Tt7;
            Pt8 = Pt7;
            P8  = Pt8/M_Pt_P_inv(M8,g);
            T8  = Tt8/M_Tt_T_inv(M8,g);
            u8  = M8*sqrt(g*R8*T8);
            
            % Station 9 Properties
            P9    = interp1(atm.h,atm.P,h1); % ambient pressure BC
            mdot9 = mdot_mixer;
            Tt9   = Tt7;
            Pt9   = Pt8;
            M9    = M_Pt_P(Pt9/P9,g);
            T9    = Tt9/M_Tt_T_inv(M9,g);
            u9    = M9*sqrt(g*R7*T9);
            A9    = A8*mft_calc(M8,g)/mft_calc(M9,g);
            
            % Gross Thrust
            Cfg = 0.96;         % Given
            Fg  = Cfg*mdot9*u9; % Pressures equal and cancel out
            
            % Subtract ram drag and cowl drag to get net thrust, FN.
            Acowl = 0.1*A0_g;
            Dram = mdot0*u0;
            Dcowl = .5*rho0*u0^2*Cd*Acowl;
            FN = Fg-Dram-Dcowl; % Last equation on slide 5 on slide set d.
            
            % If FN does not match required for the flight condition, update A0.
            if FN < FN_g - 0.001 || FN > FN_g + 0.001
                if FN < FN_g
                    A0_l = A0_g;
                else
                    A0_h = A0_g;
                end
                
                A0_g = (A0_h+A0_l)/2;
                
            else
                exit = true;
            end
            
        end
        
        % Data Collection
        % mc is now known, get outputs
        A0s(m,n)  = A0_g;
        mdotxs(m,n) = mdotx;
        TSFC(m,n) = mdotx*32.174*3600/FN; % --> lbm/hr
        Isp(m,n)  = 3600/TSFC(m,n);
        ST(m,n)   = FN/mdot0;
    end    
end

%% Plotting
for i = 1:length(phis)
    figure(1); hold on
    plot(PIs_fan,TSFC(i,:),'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
    
    figure(2); hold on
    plot(PIs_fan,Isp(i,:), 'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
    
    figure(3); hold on
    plot(PIs_fan,ST(i,:), 'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
end

figure(1)
xlabel('PI Fan')
ylabel('Thrust Specific Fuel Consumption [lbm/hr]')

figure(2)
xlabel('PI Fan')
ylabel('Isp [s]')

figure(3)
xlabel('PI Fan')
ylabel('Specific Thrust [lbs s/slug)]')

%% Test Plots

for i = 1:length(phis)
    figure(4); hold on
    plot(A0s(i,:),TSFC(i,:),'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
    
    figure(5); hold on
    plot(A0s(i,:),Isp(i,:), 'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
    
    figure(6); hold on
    plot(A0s(i,:),ST(i,:), 'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
end

figure(4)
xlabel('A0 [ft^2]')
ylabel('Thrust Specific Fuel Consumption [lbm/hr]')

figure(5)
xlabel('A0 [ft^2]')
ylabel('Isp [s]')

figure(6)
xlabel('A0 [ft^2]')
ylabel('Specific Thrust [lbs s/slug)]')

