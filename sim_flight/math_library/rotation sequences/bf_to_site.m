function [w] = bf_to_site(psi,theta,phi,v)
%BF_TO_SITE Transform body frame vectors to site frame.
%   [W] = BF_TO_SITE(YAW,PITCH,ROLL,V) is the vector v expressed in the
%   coordinates of the site frame. YAW, PITCH, ROLL are expressed in
%   degrees.

w = quat_rot([0 0 1], alpha, v);
end