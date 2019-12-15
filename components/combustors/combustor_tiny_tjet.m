function [  ] = combustor_tiny_tjet()

dhb1 = 18500; % Btu/lbm
dhb = dhb1*25037; % lbf ft/slug R
cp1 = 0.3; % BTU/(lbm F)
cp  = cp1*25037; % ft^2/s^2

Pt4 = Pt3;
Tt4 = 2600 + 460.67; % R

f = cp*(Tt4-Tt3)/(dhb-cp*Tt4);
%f = cp*(Tt4-Tt3)/dhb; % introduces 5% error

end

