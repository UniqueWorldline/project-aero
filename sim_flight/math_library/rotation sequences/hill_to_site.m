function [w] = hill_to_site(alpha,psi,theta,phi,v)
%HILL_TO_SITE Transform hill frame vectors to site frame.
%   [W] = HILL_TO_SITE(ALPHA,YAW,PITCH,ROLL,V) is the vector v expressed in
%   the coordinates of the site frame. ALPHA, YAW, PITCH, ROLL are
%   expressed in degrees.

w = bf_to_site(psi, theta, phi, hill_to_bf(alpha,v));
end