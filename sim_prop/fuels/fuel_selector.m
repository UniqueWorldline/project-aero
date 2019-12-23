function [ LHV ] = fuel_selector( fuel )

if fuel == "jp8"   
    LHV = 43.17*10^6;  
elseif fuel == "jeta"
    LHV = 43.12*10^6;
else
    error([char(fuel), 'fuel not instantiated.'])
end


end

