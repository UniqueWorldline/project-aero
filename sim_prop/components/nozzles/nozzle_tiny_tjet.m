function [ v9 ] = nozzle_tine_tjet( Tt5,Pt5,P0,v0,Cpm,g )


v9 = sqrt(2*Cpm*Tt5*(1-(P0./Pt5).^(g/(g-1)) ));


end

