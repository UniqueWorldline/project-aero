clear, clc, close all
converter_database();
property_database();

% Air properties
Rair = gas.air.Rdryair.metric;
Cpair = gas.air.CPdryair.metric;
gair = gas.air.gamma;

altitude = 0*conv.l.fttom;
[T0,P0,rho0,~] = atmosphere_heister_metric(altitude,false);

v0 = 100;
a0 = sqrt(gair*Rair*T0);
M0 = v0/a0;

Tt0 = T0*M_Tt_T_inv(M0,gair);
Pt0 = P0*M_Pt_P_inv(M0,gair);

phis = 0.01:0.01:1;

for k = 1:length(phis)
    phi = phis(k);
    [ Isp(k),TSFC(k),ST(k) ] = assembly_tiny_tjet( Tt0,Pt0,M0,a0,phi );
    
end

num_subplots = 3;
figure(1); hold on;

subplot(num_subplots,1,1);
plot(phis,Isp);
xlabel('Throttle Setting')
ylabel('Isp [s]')

subplot(num_subplots,1,2);
plot(phis,TSFC);
xlabel('Throttle Setting')
ylabel('TSFC [(kg/s)/N')

subplot(num_subplots,1,3);
plot(phis,ST);
xlabel('Throttle Setting')
ylabel('Specific Thrust (N/(kg/s)')
