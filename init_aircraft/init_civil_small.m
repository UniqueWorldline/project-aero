%%=======================================================================%%
%%==========================  CIVIL SMALL  ==============================%%
%%=======================================================================%%

%% Aerodynamic Forces

% Aero forces
plane.aero.aoa_ref = linspace(-5,15,10);
plane.aero.CL = linspace(-0.6,1.8,10);
plane.aero.CD = linspace(-20,20,10);


%% Mass Properties

% Passenger Mass Calculation
plane.num_passengers = 0;
avg_passenger_mass = 70; % kg
total_passenger_mass = avg_passenger_mass*plane.num_passengers;

% Mass properties
plane.mass.emptymass = 25000; % kg
plane.mass.fuel = 7000; % kg
plane.mass.payload = 0;
plane.mass.passengers = total_passenger_mass;


clearvars -except plane
