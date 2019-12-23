function [w] = hill_to_bf(alpha,v)
%HILL_TO_BF Rotates V from the hill frame to the body frame.
%   [W] = HILL_TO_BF(ALPHA,V) is the vector v expressed in the
%   coordinates of the body frame. ALPHA is expressed in
%   degrees.

w = quat_rot([0 0 1], -alpha, v);
end