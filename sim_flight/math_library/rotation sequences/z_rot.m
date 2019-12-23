function [w] = z_rot(psi,v)
%Z_ROT Performs a point rotation about the z axis on the vector V.
%   [W] = Z_ROT(PSI,V) returns the vector W rotated about the z-axis PSI
%   degrees.

w = quat_rot([0 0 1], psi,v);
end