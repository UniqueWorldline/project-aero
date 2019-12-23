clear, clc, close all
%% Define tst vectors to use in quaternion construction
x = [1 0 0];
y = [0 1 0];
z = [0 0 1];

%% Test 1 - two pure quaternions

% x-unit vectors
p = [0 x];
q = [0 x];
w = quat_product(p,q);

% The correct answer is:
ca = [-dot(x,x), cross(x,x)]';
if w == ca
    disp('success')
else
    warning('failure')
end

% y-unit vectors
p = [0 y];
q = [0 y];
w = quat_product(p,q);

% The correct answer is:
ca = [-dot(y,y), cross(y,y)]';
if w == ca
    disp('success')
else
    warning('failure')
end

% z-unit vectors
p = [0 z];
q = [0 z];
w = quat_product(p,q);

% The correct answer is:
ca = [-dot(z,z), cross(z,z)]';
if w == ca
    disp('success')
else
    warning('failure')
end

%% Test 2 - random quaternions
p = [5 (-4.04*x+22*y-5*z)];
p0 = p(1);
p_vec = p(2:4);

q = [-5.7853 (11*x - 4.75*y + 100*z)];
q0 = q(1);
q_vec = q(2:4);

w = quat_product(p,q);

% The correct answer is:
ca = [(p0*q0)-dot(p_vec,q_vec), p0*q_vec + q0*p_vec + cross(p_vec,q_vec)]';
if round(w,5) == round(ca,5)
    disp('success')
else
    w
    ca
    w == ca
    warning('failure')
end
