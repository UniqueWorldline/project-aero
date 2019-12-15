%% Flight System Comparison
clear, clc, close all
load('results_Tjet')
load('results_Tjet_ab')
load('results_Tfan')
load('results_ram')
load('results_scram')
load('results_rocket')
load('dpc')

imax = max(M0_scram) <= M0_dpc;
imax = find(imax,1);


f = figure; hold on;
set(f,'Position',[50,50,1000,800])
plot(tjet_M0,tjet_Isp)
plot(tjet_ab_M0,tjet_ab_Isp)
plot(tfan_M0,tfan_Isp)
plot(M0_ram,Isp_ram)
plot(M0_scram,Isp_scram)
plot(M0_rocket,Isp_rocket)
yyaxis right
plot(M0_dpc(1:imax),Hvector_dpc(1:imax))


yyaxis left
ax = gca;

FontSize1 = 16;
FontSize2 = 14;
FontSize3 = 20;
ax.FontSize = FontSize2;
set(ax,'TickLabelInterpreter','Latex')
legend('Turbojet','Turbojet (A/B)','Turbofan','Ramjet','Scramjet','Rocket','q corridor',...
       'FontSize',FontSize2,'Interpreter','Latex','Location','SoutheastOutside')
xlabel('$M_0$','Interpreter','Latex','FontSize',FontSize1)
ylabel('$I_{sp} [s]$','Interpreter','Latex','FontSize',FontSize1)
yyaxis right
ylabel('Height [ft]','Interpreter','Latex','FontSize',FontSize1)
ax.YAxis(2).Exponent = 0;
title('Propulsion System Performance Comparison','Interpreter','Latex','FontSize',FontSize3)

saveas(f,'Isp Graph.png')
