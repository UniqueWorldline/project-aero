function [output] = isenflow(M, mdot, Tt, Pt, g, R, A, A1)
%ISENFLOW simulates isentropic flow from one point to point 1.
%   [output] = isenflow(M, mdot, Tt, Pt, g, A, A1)


mft = mft_calc(M,g);

% Total properties at 1
Tt1 = Tt;
Pt1 = Pt;

% Mass flow and mass flow function at 1
mdot1 = mdot;
mft1 = A*mft/A1;

% Mach number at 1 (sub or supersonic branch)
if M > 1
    M1 = m_sup_mft(mft1, g, 0.001)
elseif M == 1
    if A1 > A
        M1 = m_sup_mft(mft1, g, 0.001)
    elseif A1 == A
        M1 = M;
    else
        M1 = m_sub_mft(mft1, g, 0.001)
    end
else
    M1 = m_sub_mft(mft1, g, 0.001)
end

% Static properties at 1
T1 = Tt1/M_Tt_T_inv(M1,g);
P1 = Pt1/M_Pt_P_inv(M1,g);

% Speed at 1
u1 = M1*sqrt(g*R*T1);

% output definition
output = [M1 mft1 mdot1 Tt1 Pt1 T1 P1 u1];

end

