clear, clc, close all

% Simulate positive spacecraft roll
u = [1 0 0];
theta = 10;
v = [0 1 0];
w = quat_rot(u,theta,v)

% Simulate positive spacecraft pitch
u = [0 1 0];
theta = 10;
v = [1 0 0];
w = quat_rot(u, theta, v)

% Simulate positive spacecraft yaw
u = [0 0 1];
theta = 10;
v = [1 0 0];
w = quat_rot(u, theta, v)
