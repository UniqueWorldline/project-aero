function [N] = quat_norm(q)
%QUAT_NORM Find the norm of Q.
%   [N] = QUAT_NORM(Q) find the norm of the quaternion Q. It does not
%   convert Q to a unit quaternion.

if length(q) ~= 4
    error('q does not have 4 components. It therefore is not a quaternion')
end

N = sqrt( quat_product(quat_conj(q),q) );
N = N(1);

end

