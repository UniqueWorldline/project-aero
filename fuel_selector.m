function [ LHV,Cp,AF,M ] = fuel_selector( fuel )

if fuel == "std_a"
    LHV = 10^7; % J/kg
    Cp = 2600; % J/kg K
    M = 150;
    AF = 14.4;
    
elseif fuel == "jp8"   
    LHV = 43.17*10^6;
    Cp = 2.6*1000; % J/kg K
    M = 154.3; % kg/kmol
    
elseif fuel == "jeta"
    LHV = 43.12*10^6;
    Cp = NaN;
    AF = 15;
    
elseif fuel == "kerosine"
    LHV = 18500*conv.e.btutoj/conv.m.lbmtokg; % 43000 kJ/kg
    Cp = 0.3; % BTU/lbm-deg F 
else
    error([char(fuel), 'fuel not instantiated.'])
    
    
end


end

