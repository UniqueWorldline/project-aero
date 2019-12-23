clear, clc, close all
tspan = [-200 200];
y0 = [1 -2 4];

opts = odeset('Events',@myEventsFcn);
[t,Y,te,ye,ie] = ode45(@(t,states) myfun1(states), tspan, y0,opts);

figure; hold on;
plot(t,Y(:,1),'DisplayName','y1')
plot(t,Y(:,2),'DisplayName','y2')
plot(t,Y(:,3),'DisplayName','y3')
l = legend('show');
set(l,'Location','NortheastOutside')