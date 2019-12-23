function [r] = quat_product(p,q)
%QUAT_PRODUCT multiplies two quaternions p and q.
%   [R] = QUAT_PRODUCTS(P,Q) performs the operation r = pq where pq is the
%   quaternion product of the quaternions p and q.


p0 = p(1);
p1 = p(2);
p2 = p(3);
p3 = p(4);

q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

% Define the P matrix
P = [p0 -p1 -p2 -p3;...
     p1  p0 -p3  p2;...
     p2  p3  p0 -p1;...
     p3 -p2  p1  p0];
 
% Define the q 4-vector 
Q = [q0 q1 q2 q3]';

% Perform the quaternion multiplication as matrix multiplicaiton
r = P*Q;

end

