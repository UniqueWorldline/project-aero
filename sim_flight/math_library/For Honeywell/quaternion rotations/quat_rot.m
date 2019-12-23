function [w] = quat_rot(u,theta,v,rad_flag)
%QUAT_ROT rotates a vector using quaternions.
%   [W] = QUAT_ROT(U,THETA,V) rotates the 3D vector V by the angle THETA in
%   degrees about the unit vector U.
%
%   [W] = QUAT_ROT(U,THETA,V,RAD_FLAG) allows the user to enter the angle
%   THETA in radians if RAD_FLAG is true.
%
%   The angle theta is measured as positive if the vector component of q is
%   coming out of the page and the projection of the vector v in the plane
%   of rotation, n, rotates counter clockwise to become the vector m. If
%   the invarient component of v (parallel to the vector q) is named a,
%   such that v = a + n, the final vector, w, is constructed as w = a + m.
%
%
%                    ooo OOO OOO ooo
%                oOO                 OOo
%            oOO                         OOo
%         oOO                               OOo
%       oOO                      m            OOo
%     oOO                       /|              OOo
%    oOO                        /                OOo
%   oOO                        /                  OOo
%  oOO                        /                    OOo
%  oOO                       / theta               OOo
%  oOO                      X---------->n          OOo
%  oOO                                             OOo
%  oOO                                             OOo
%   oOO                                           OOo
%    oOO                                         OOo
%     oOO                                       OOo
%       oOO                                   OOo
%         oO                                OOo
%            oOO                         OOo
%                oOO                 OOo
%                    ooo OOO OOO ooo
%
%   X is the tip of the vector q that is pointing out of the page.
%
%   This function constructs the rotation quaternion q as 
%
%       q = cos(theta/2) + U*sin(theta/2)
%
%   Therefore, theta is the desired angle of rotation, not twice the
%   desired angle of rotation.
%
%   See page 130 and 131 of Quaternions and Rotation Sequences by Jack B.
%   Quipers for more information.

if nargin == 3
    rad_flag = false;
    theta = theta*pi/180;
elseif nargin == 4 & rad_flag == false
    theta = theta*pi/180;    
end

% Construct Q as a unit quaternion
if length(u) == 4
    warning(['u was entered as a quaternion with length(u) == 4.'...
             'Attempting to convert to a unit quaternion now.'])
    
    if length(u) ~= 3
        error('u is not length 3 or 4. Unable to convert u to a pure quaternion')
    else
        u = u(2:4);
    end
end

if norm(u) ~= 1
    N = norm(u);
    u = u./N;
    if round(norm(u),10) ~= 1
        error('Normalization didnt work.')
    end
end

% Make v into a pure quaternion
v = [0 v];

% Construct the rotator quaternion and its conjugate.
q = [cos(theta/2), u*sin(theta/2)];
q_star = quat_conj(q);

% Perform the rotation
w = quat_product(q,quat_product(v,q_star)); % qvq*

if w(1) >= 10^-10 || w(1) <= -10^-10
    error(['Rotation operator returned a non-pure quaternion, '...
          num2str(w), '. Output is not a 3-dimensional vector.'])
end

% Reduce w to a 3D vector.
w = [w(2) w(3) w(4)];


end

