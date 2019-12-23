%% Problem 1 - Constant Dynamic Pressure Flight Corridor
clear, clc, close all

% Inputs
Hvector = linspace(0, 80000,1000);
GeometricFlag = 1;

% Atmosphere Model
[temp,press,rho,Hgeopvector] = atmosphere(Hvector,GeometricFlag);


qs = [800, 1000, 1200]; % psf
for i = 1:length(qs)
    q = qs(i);
    
    % Find speed of sound
    R = 1717;
    g = 1.4; % gamma
    g1 = (g-1)/2;
    g2 = g/(g-1);
    a = sqrt(g*R*temp);
    
    
    % Find Mach Number (Part A)
    v = sqrt(2./rho*q);
    M = v./a;
    
    figure(1)
    hold on
    plot(M,Hvector)
    xlabel('M')
    ylabel('Altitude [MSL, ft]')
    ax = gca;
    ax.XRuler.Exponent = 0;
    ax.YRuler.Exponent = 0;
    
    
    % Find Stagnation Temperature (Part B)
    % Note: T_stag = Tt
    
    Tt = (1 + (g-1).*M.^2/2).*temp;
    
    figure(2)
    hold on
    plot(Hvector,Tt)
    xlabel('Altitude [MSL, ft]')
    ylabel('Stagnation Temperature [R]')    
    ax = gca;
    ax.XRuler.Exponent = 0;
    ax.YRuler.Exponent = 0;    
    
    % Find Recovery Temperature (Part C)
    
    r = .73^(1/3); % recovery coefficient
    Tr = temp .* (1 + r*(g-1)/2.*M.^2);
    
    figure(3)
    hold on
    plot(Hvector,Tr)
    xlabel('Altitude [MSL, ft]')
    ylabel('Recovery Temperature [R]')
    ax = gca;
    ax.XRuler.Exponent = 0;
    ax.YRuler.Exponent = 0;    
    
    % Find Stagnation Pressure (Part D)
    Pt = press .* (1 + g1 .* M.^2).^g2;
    
    figure(4)
    hold on
    plot(Hvector,Pt)
    xlabel('Altitude [MSL, ft]')
    ylabel('Total Pressure [psf]')
    ax = gca;
    ax.XRuler.Exponent = 0;
    ax.YRuler.Exponent = 0;    
    
    % Static Pressure is already known (Part E)
    
    figure(5)
    hold on
    plot(Hvector,press)
    xlabel('Altitude [MSL, ft]')
    ylabel('Static Pressure [psf]')
    ax = gca;
    ax.XRuler.Exponent = 0;
    ax.YRuler.Exponent = 0;
    
end
