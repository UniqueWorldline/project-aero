function [ statesdot ] = phase_cruise( states )
%PHASE_CRUISE Simulates cruise flight of a fixed wing aircraft

%% Input Porcessing

% Site frame position (m)
s_x = states(1);
s_y = states(2);
s_z = states(3);
s_pos = [s_x; s_y; s_z];

% Site frame velocity (m/s)
s_vx = states(4);
s_vy = states(5);
s_vz = states(6);
s_v = [s_vx; s_vy; s_vz];

% yaw pitch roll (deg)
psi   = states(7);
theta = states(8);
phi   = states(9);

% heading rate, pitch rate, roll rate (deg)
psidot   = states(10);
thetadot = states(11);
phidot   = states(12);

% Throttle and total mass
t = states(10);
m = states(11);

% Transformations
bd_v = aerospace_sequence(psi, theta, phi, s_v, true);


%% Cruise Model

% Propulsion Forces


% Aerodynamic Forces


% Aerodynamic Moments


% F=ma

% Kinematics


%% Output Processing

statesdot = [ vx;...
              vy;...
              vz;...
              ...
              ax;...
              ay;...
              az;...
              ...
              psidot;...
              thetadot;...
              phidot;...
              ...
              psiddot;...
              thetaddot;...
              phiddot;...
              ...
              tdot;...
              mdot ];
          
          
end

