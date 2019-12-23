function [w] = site_to_bf(psi,theta,phi,v)
%BF_TO_SITE Transform site frame vectors to body frame.
%   [W] = SITE_TO_BF(YAW,PITCH,ROLL,V) is the vector v expressed in the
%   coordinates of the body frame. YAW, PITCH, ROLL are expressed in
%   degrees.

w = aerospace_sequence(psi,theta,phi,v,true);
end