function [q_star] = quat_conj(q)
%QUAT_CONJ Find the conjugate of a quaternion.
%   [Q_STAR] = QUAT_CONJ(Q) returns the conjugate of Q, Q_STAR.

q_star = [q(1), -q(2), -q(3), -q(4)];
end

