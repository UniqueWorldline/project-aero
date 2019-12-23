function plane = fuel_gauge(plane)

max_usable_fuel = 1425.03;
usable_fuel_remaining = plane.usablefuelmass;
frac_remaining = usable_fuel_remaining/max_usable_fuel;







if frac_remaining < 1 && plane.fuel_flag.full == 0
    disp('100% Fuel Remaining')
    plane.fuel_flag.full = 1;
    
elseif frac_remaining < 0.9 && plane.fuel_flag.ninety == 0
    disp('90% Fuel Remaining')
    plane.fuel_flag.ninety = 1;
    
elseif frac_remaining < 0.8 && plane.fuel_flag.eighty == 0
    disp('80% Fuel Remaining')
    plane.fuel_flag.eighty = 1;
    
elseif frac_remaining < 0.7 && plane.fuel_flag.seventy == 0
    disp('70% Fuel Remaining')
    plane.fuel_flag.seventy = 1;
    
elseif frac_remaining < 0.6 && plane.fuel_flag.sixty == 0
    disp('60% Fuel Remaining')
    plane.fuel_flag.sixty = 1;
    
elseif frac_remaining < 0.5 && plane.fuel_flag.fifty == 0
    disp('50% Fuel Remaining')
    plane.fuel_flag.fifty = 1;
    
elseif frac_remaining < 0.4 && plane.fuel_flag.fourty == 0
    disp('40% Fuel Remaining')
    plane.fuel_flag.fourty = 1;

elseif frac_remaining < 0.3 && plane.fuel_flag.thirty == 0
    disp('30% Fuel Remaining')
    plane.fuel_flag.thirty = 1;
    
elseif frac_remaining < 0.2 && plane.fuel_flag.twenty == 0
    disp('20% Fuel Remaining')
    plane.fuel_flag.twenty = 1;
    
elseif frac_remaining < 0.1 && plane.fuel_flag.ten == 0
    disp('10% Fuel Remaining')
    plane.fuel_flag.ten = 1;
    
elseif frac_remaining < 0.01 && plane.fuel_flag.one == 0
    disp('1% Fuel Remaining')
    plane.fuel_flag.one = 1;
end

