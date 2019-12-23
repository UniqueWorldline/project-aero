function [ statesdot ] = myfun1(states)

x = states(1);
y = states(2);
z = states(3);

factor = 0.01;

xdot = factor*(-(x + y));
ydot = factor*(y - z);
zdot = factor*(z - x);

statesdot = [ xdot ydot zdot ]';

end

