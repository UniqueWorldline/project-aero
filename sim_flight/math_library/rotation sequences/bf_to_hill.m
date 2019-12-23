function [w] = bf_to_hill(alpha,v)
%BF_TO_HILL Transform body frame vectors to hill frame.
%   [W] = BF_TO_HILL(ALPHA,V) is the vector v expressed in the coordinates
%   of the hill frame. ALPHA is the attack angle of the rover relative to
%   the steepest upslope direction.

w = quat_rot([0 0 1], alpha, v);
end

