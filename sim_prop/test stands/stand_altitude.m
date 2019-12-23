clear, clc, close all
converter_database();
property_database();

% Air properties
Rair = gas.air.Rdryair.metric;
Cpair = gas.air.CPdryair.metric;
gair = gas.air.gamma;

% Input parameters
altitudes = (0:500:30000)*conv.l.fttom;
phi = 1;

for k = 1:length(altitudes)
    
    tic;
    
    altitude = altitudes(k);
    [ T0,P0,rho0,~ ] = atmosphere_heister_metric(altitude,false);
    
    v0 = 100;
    a0 = sqrt(gair*Rair*T0);
    M0 = v0/a0;
    
    Tt0 = T0*M_Tt_T_inv(M0,gair);
    Pt0 = P0*M_Pt_P_inv(M0,gair);
    [ Isp(k),TSFC(k),ST(k) ] = assembly_tiny_tjet( Tt0,Pt0,M0,a0,phi );
    
    dt = toc;
    disp([num2str(altitude), 'm altitude test completed in ', num2str(dt), ' seconds.'])
    
end

num_subplots = 3;
figure(1); hold on;

subplot(num_subplots,1,1);
plot(altitudes,Isp);
xlabel('Altitude [m]')
ylabel('Isp [s]')

subplot(num_subplots,1,2);
plot(altitudes,TSFC);
xlabel('Altitude [m]')
ylabel('TSFC [(kg/s)/N')

subplot(num_subplots,1,3);
plot(altitudes,ST);
xlabel('Altitude [m]')
ylabel('Specific Thrust (N/(kg/s)')
