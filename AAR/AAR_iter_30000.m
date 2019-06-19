%% Air Augmented Rocket
% Aerospace Propulsion Final Project - Part 1
clear, clc, close all
run('startup')

% Gamma
g = 1.4;
 
% Choose the study parameter values
A0s = linspace(0.5,15,200);
phis = [1 2 10 1000];

% Specify flight condition values
% Launch (flight condition 1)
h1 = 30000; % 30000 ft
M1 = 0.8;
pi_d_1 = 0.96;
Cd = 0.2;
FN_g = 4000; % Required thrust


% Freestream conditions (station 0) (flight condition 1)
Ttrto = M_Tt_T_inv(M1,g);
Ptrto = M_Pt_P_inv(M1,g);

Tt0 = Ttrto * interp1(atm.h,atm.t,h1);
Pt0 = Ptrto * interp1(atm.h,atm.P,h1);

T0  = Tt0/Ttrto;
P0  = Pt0/Ptrto;

u0 = M1*sqrt(g*gas.prop.R_dryair*T0);
rho0 = P0/(gas.prop.R_dryair*T0);

mft0 = mft_calc(M1,g);

for m = 1:length(phis)
    for n = 1:length(A0s)
        
        
        % Select an A0 and a chamber equivalence ratio (phi)
        phi = phis(m);
        A0 = A0s(n);
        
        % Compute mdot0 = m15 from A0.
        mdot0  = Pt0*A0*mft0 / sqrt(gas.prop.R_dryair*Tt0);
        mdot15 = mdot0;
        
        % Flight condition and recovery determine Pt15.
        Pt15 = pi_d_1*Pt0;
        
        % For the legislated M15=0.2, all properties at 15 are now specified.
        M15   = 0.1; % Given
        Tt15  = Tt0;
        Pt15  = Pt15;
        P15   = Pt15/M_Pt_P_inv(M15,g);
        mft15 = mft_calc(M15,g);
        A15   = mdot15*sqrt(gas.prop.R_dryair*Tt15)/(Pt15*mft15);
        T15   = Tt15/M_Tt_T_inv(M15,g);
        u15   = M15*sqrt(g*gas.prop.R_dryair*T15);
        
        % Find mdot_c by regula falsi
        MC_l = 0;
        MC_h = 1;
        MC_g = (MC_h+MC_l)/2;
        
        exit = false;
        while exit == false
            % For the selected phi, (and beta =0) compute mass flows of H and O.
            yO = 32/(4*phi+32); % gas.O2.MM*1/(gas.H2.MM*2*phi+gas.O2.MM*2*phi);
            yH = 4*phi/(4*phi+32);% gas.H2.MM*2*phi/(gas.H2.MM*2*phi+gas.O2.MM*1);
            yN = 0;
            
            mdotO = yO*MC_g;
            mdotH = yH*MC_g;
            mdotx = mdotO+mdotH;
            
            % Compute Ttx.
            CpH = g*(gas.RR/gas.H2.MM)/(g-1);
            CpO = g*(gas.RR/gas.O2.MM)/(g-1);
            
            T_inject = 540;
            h_init_x = (mdotH*CpH*T_inject + mdotO*CpO*T_inject)/mdotx;
            
            Ttx = Ttbrn_yHyOyNhi(yH, yO, yN, h_init_x, g);
            
            % From PX = P15, compute the properties at the rocket exit.
            Px = P15;
            Ptx = 2E5;
            ptp_x = Ptx/Px;
            Mx = M_Pt_P(ptp_x,g);
            Tx = Ttx/M_Tt_T_inv(Mx,g);
            mft_x = mft_calc(Mx,g);
            
            MWT = MWT_yHyOyN(yH,yO,yN);
            R_mix = 49710/MWT;               % CL
            Cp_mix = R_mix*g/(g-1);
            
            Ax = mdotx*sqrt(R_mix*Ttx)/(Ptx*mft_x);
            ux = Mx*sqrt(g*R_mix*Tx);
            
            % Now all quantities flowing into the mixer are known.
            % Solve for station 7 properties and then gross thrust.
            
            %% Mixer Properties
            Amixer = Ax+A15;
            mdot_mixer = mdotx + mdot15;
            mdot7 = mdot_mixer;
            Ix = mdotx*ux+Px*Ax;
            I15 = mdot15*u15+P15*A15;
            Imixer = Ix + I15;
            I7 = Imixer;
            
            
            %% Station 7 Properties
            
            % Find R_7
            yO_15    = gas.O2.m_frac;
            yN_15    = gas.N2.m_frac;
            
            mdotO_15 = mdot15*yO_15;
            mdotN_15 = mdot15*yN_15;
            
            yO_7     = (mdotO_15 + mdotO)/mdot7; % combine the oxygen species
            yN_7     = mdotN_15/mdot7;           % only comes from air
            yH_7     = mdotH/mdot7;              % only comes from fuel
            
            MWT = MWT_yHyOyN(yH_7,yO_7,yN_7);
            R7 = 49710/MWT; % CL
            Cp7 = R7*g/(g-1);
            
            % Find Tt7 and ht7
            mdot7 = mdot_mixer;
            A7    = Amixer;
            h_init_7 = ( (mdotH*CpH+mdotO*CpO)*T_inject...
                     + mdot15*gas.prop.cp_dryair*Tt15 )...
                     / mdot7;
                 
            Tt7 = Ttbrn_yHyOyNhi(yH_7,yO_7,yN_7,h_init_7,g);
            ht7 = Cp7*Tt7;
            
            % Find M7
            mfi7 = ht7*(mdot7/I7)^2;
            M7 = m_sub_mfi(mfi7,g);
            T7 = Tt7/M_Tt_T_inv(M7,g);
            
            % Find remaining properties
            u7   = M7*sqrt(g*R7*T7);
            rho7 = mdot7/(u7*Amixer);
            P7   = rho7*R7*T7;
            Pt7  = P7*M_Pt_P_inv(M7,g);
            
            
            %% Station 8 Properties
            M8  = 1; % Given
            A8  = A7*mft_calc(M7,g)/mft_calc(M8,g);
            Tt8 = Tt7;
            Pt8 = Pt7;
            
            %% Station 9 Properties
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
            Acowl = 0.1*A0;
            Dram = mdot0*u0;
            Dcowl = .5*rho0*u0^2*Cd*Acowl;
            FN = Fg-Dram-Dcowl; % Last equation on slide 5 on slide set d.

            
            % If FN does not match required for the flight condition, update mdot_c.
            if FN < FN_g - 0.001 || FN > FN_g + 0.001
                if FN < FN_g
                    MC_l = MC_g;
                else
                    MC_h = MC_g;
                end
                
                MC_g = (MC_h+MC_l)/2;
                
            else                   
                exit = true;
            end
            
        end
        
        % Data Collection
        % mc is now known, get outputs 
        TSFC(m,n) = mdotx*32.174*3600/FN; % --> lbm/hr
        Isp(m,n)  = 3600/TSFC(m,n);
        ST(m,n)   = FN/mdot0;
        
    end
end

%% Plotting
for i = 1:length(phis)
    figure(1); hold on
    plot(A0s,TSFC(i,:),'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
    
    figure(2); hold on
    plot(A0s,Isp(i,:), 'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
    
    figure(3); hold on
    plot(A0s,ST(i,:), 'DisplayName',['Phi = ', num2str(phis(i))])
    legend('show')
end

figure(1)
xlabel('A0 [ft^2]')
ylabel('Thrust Specific Fuel Consumption [lbm/hr]')

figure(2)
xlabel('A0 [ft^2]')
ylabel('Isp [s]')

figure(3)
xlabel('A0 [ft^2]')
ylabel('Specific Thrust [lbs s/slug)]')


