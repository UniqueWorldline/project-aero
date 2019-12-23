function [ w ] = aerospace_sequence(psi, theta, phi, v, rev)
%AEROSPACE_SEQUENCE Rotates a vector using the aerospace sequence.
%   [W] = AEROSPACE_SEQUENCE(YAW, PITCH, ROLL, V) rotates the vector V
%   from body frame coordinates to site frame coordinates using body frame
%   attitude information. YAW, PITCH, and ROLL should be in degrees.
%
%   [W] = AEROSPACE_SEQUENCE(YAW, PITCH, ROLL, V, REV) will perform the
%   reverse aerospace sequence, transforming V from site frame to body
%   frame, if REV is true.

% Unit vectors and half angles.
x = [1 0 0];
y = [0 1 0];
z = [0 0 1];

psi   = psi   * pi/180;
theta = theta * pi/180;
phi   = phi   * pi/180;

if nargin == 5 && rev == true
    % Find the composite quaternion rotator.
    qx_phi   = [cos(phi/2)   x*sin(phi/2)];
    qy_theta = [cos(theta/2) y*sin(theta/2)];
    qz_psi   = [cos(psi/2)   z*sin(psi/2)];
    q_comp   = quat_product(qz_psi, quat_product(qy_theta,qx_phi));
    q_comp_star = quat_conj(q_comp);
    
    % Find the axis and angle of rotation.
    delta = 2 * acosd(q_comp_star(1));
    u1 = q_comp_star(2);
    u2 = q_comp_star(3);
    u3 = q_comp_star(4);
    u = [u1 u2 u3];
    
    % Calculate the rotation of the vector v.
    w = quat_rot(u, delta, v);
else
    % Find the composite quaternion rotator.
    qx_phi   = [cos(phi/2)   x*sin(phi/2)];
    qy_theta = [cos(theta/2) y*sin(theta/2)];
    qz_psi   = [cos(psi/2)   z*sin(psi/2)];
    q_comp   = quat_product(qz_psi, quat_product(qy_theta,qx_phi));
    
    % Find the axis and angle of rotation.
    delta = 2 * acosd(q_comp(1));
    u1 = q_comp(2);
    u2 = q_comp(3);
    u3 = q_comp(4);
    u = [u1 u2 u3];
    
    % Calculate the rotation of the vector v.
    w = quat_rot(u, delta, v);
end

end






