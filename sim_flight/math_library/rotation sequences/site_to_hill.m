function [w] = site_to_hill(alpha,psi,theta,phi,v)
%SITE_TO_HILL Transform site frame vectors to HILL frame.
%   [W] = SITE_TO_HILL(ALPHA,YAW,PITCH,ROLL,V) is the vector v expressed in
%   the coordinates of the hill frame. ALPHA, YAW, PITCH, ROLL are
%   expressed in degrees.

w = bf_to_hill(alpha, site_to_bf(psi,theta,phi,v));
end