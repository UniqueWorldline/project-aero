function [PtDPtU] = ns_pt(mu,g)

g1 = g/(g-1);
g2 = -1/(g-1);
g3 = (g+1)/2;
g4 = (g-1)/2;
g5 = 2*g/(g+1);

t1 = (g3*mu^2/(1+g4*mu^2))^g1;
t2 = (1 + g5 * (mu^2-1))^g2;
PtDPtU = t1*t2;


end