% EKF Based Battery SOC Estimation
% Author: AYUSH KUMAR
% Project: Battery Management System

clc; clear; close all;
format long

%% PARAMETERS
v = 0;
v_target = 15; % Initially desired(Target) Speed
m = 1200; % Mass of Vehicle (kg)
g = 9.81; % Gravitational Acceleration (m/sec^2)
Cr = 0.01; % Rolling Resistance Coefficient
rho = 1.2; % Air Resistance
A = 2.2; % Frontal Area (m^2)
Cd = 0.3; % Drag Coefficient
R = 0.3; % Wheel Radius (metre)
Capacity = 50; % Ah
R_internal = 0.05; % Battery's Internal Resistance
eta_Motor = 0.9; % Efficiency of Motor
eta_Regen = 0.65; %Regeneration Efficiency  

dt = 0.1; % Time
t = 0:dt:3500; 

%% INITIALISATION
a = zeros(1,length(t)); % Acceleration
F_drive = zeros(1,length(t)); % Driving Force
F_drag = zeros(1,length(t)); % Drag Force
F_total = zeros(1,length(t)); % Acceleration Force
a_Actual = zeros(1,length(t)); % Actual Vehicle Acceleration
velocity = zeros(1,length(t)); % Vehicle Velocity
distance = zeros(1,length(t)); % Distance Travelled
Torque = zeros(1,length(t)); % Motor Torque
Power = zeros(1,length(t)); % Power Usage
SOC = zeros(1,length(t)); % State of Charge
V_oc = zeros(1,length(t)); % Battery Open-Circuit Voltage
V =  zeros(1,length(t)); % Battery Output Voltage
I = zeros(1,length(t)); % Battery Output Current
Efficiency = zeros(1,length(t)); % Efficiency
Energy_cons = zeros(1,length(t)); % Energy Consumption
Energy_cons_wh = zeros(1,length(t)); % Energy Consumption in 'Wh'
Energy_left = zeros(1,length(t)); % Energy left in Battery
Range_km = zeros(1,length(t)); % Range Left
Wh_per_km = zeros(1,length(t)); % Energy Consumption per Km
RPM = zeros(1,length(t)); % Motor RPM

%%  MOTION
SOC(1) = 100;
for i=1:length(t)
    
    if mod(i,50) == 0
    v_target = 0.7*v_target + 0.3*(5 + 25*rand);
    end
    throttle = 0.03*(v_target - velocity(max(i-1,1))); % Driver controller
    % Random braking events
    if rand < 0.01
        throttle = throttle - (0.2 + 0.4*rand);
    end
    throttle = max(min(throttle,0.8),-0.6); % Limiting Throttle Range

    a(i) = (throttle); 

    F_drive(i) = (m*a(i));
    F_roll = (m*g*Cr);
    F_drag(i) = (0.5*rho*A*Cd*v^2);

    F_total(i) = (F_drive(i) - F_roll - F_drag(i));
    a_Actual(i) = (F_total(i)/m);

    if i == 1
    velocity(i) = 0;
    else
    velocity(i) = (velocity(i-1) + a_Actual(i)*dt);
    end
    % Speed limits
    velocity(i) = max(velocity(i),0);   % no reverse speed
    velocity(i) = min(velocity(i),41);  % max 41 m/sBatter(=150 Kmph)
   
    if i == 1
    distance(i) = 0;
    else
    distance(i) = distance(i-1) + velocity(i)*dt;
    end
    
    Torque(i) = (F_drive(i)*R);  % Motor Torque
    if i > 1   % Smoothing Torque
    Torque(i) = 0.7*Torque(i-1) + 0.3*Torque(i);
    end

    if F_drive(i) >= 0
        % DRIVING MODE
        Power(i) = ((F_drive(i)*velocity(i))/eta_Motor);
    elseif F_drive(i) < 0
        % REGENRATIVE BRAKING (CHARGING)
        Power(i) = (eta_Regen*F_drive(i)*velocity(i)*eta_Motor);
    end
    Power(i) = max(min(Power(i), 5000), -3000); % Limiting Power

    V_oc(i) = 42 + 6*(SOC(i)/100)^0.6;
    
    I(i) = (Power(i)/V_oc(i));
     if i > 1   % Smoothing Current
        I(i) = (0.7*I(i-1) + 0.3*I(i));
     end
    I(i) = max(min(I(i), 120), -80); % Limiting Current
    V(i) = (V_oc(i) - I(i)*R_internal);
    V(i) = max(min(V(i), 45), 35); % Limiting Voltage
    
    BatteryEnergy_Wh = (Capacity*48); % Total Battery Energy
    Energy_left(i) = ((SOC(i)/100)*BatteryEnergy_Wh); 
    if i == 1
    Energy_cons(i) = 0;
    else
    Energy_cons(i) = Energy_cons(i-1) + Power(i)*dt;
    end
    Energy_cons_wh(i) = (Energy_cons(i)/3600);

    if distance(i) > 1
    Wh_per_km(i) = (Energy_cons_wh(i)/(distance(i)/1000));
    else
    Wh_per_km(i) = 0;
    end

    Wh_per_km(i) = max(Wh_per_km(i),50); % Limiting Energy Consumption
    Range_km(i) = (Energy_left(i)/Wh_per_km(i));

   
    RPM(i) = ((velocity(i)/(2*pi*R))*60);

    if i < length(t)
    SOC(i+1) = SOC(i) - (I(i)*dt)/(Capacity*3600)*100;
    end

    if SOC(i) <= 20
    break
    end
end
t = t(1:i);
velocity = velocity(1:i);
distance = distance(1:i);
Torque = Torque(1:i);
Power = Power(1:i);
SOC = SOC(1:i);
V_oc = V_oc(1:i);
V = V(1:i);
I = I(1:i);
Energy_cons_wh = Energy_cons_wh(1:i);
Range_km = Range_km(1:i);
RPM = RPM(1:i);

distance_km = (distance/1000);
drive_idx = (Power >= 0); % Logical condition
regen_idx = (Power < 0); % Logical condition

%%  PLOTTING
figure
tiledlayout(6,2)

% Velocity
nexttile
plot(t, velocity, 'y')
xlabel('Time (s)')
ylabel('Velocity (m/s)')
title('Speed vs Time')
grid on

% Distance Travelled v/s SOC
nexttile
plot(distance_km, SOC, 'LineWidth',1.5)
xlabel('Distance Travelled (Km)')
ylabel('SOC (%)')
title('SOC vs Distance')
grid on

% SOC
nexttile
plot(t(drive_idx), SOC(drive_idx), 'r', 'LineWidth', 1.5) 
hold on;
plot(t(regen_idx), SOC(regen_idx), 'c', 'LineWidth', 1.5) 
hold on;
xlabel('Time (s)')
ylabel('SOC (%)')
title('SOC with Charging & Discharging')
legend('Discharging Region', 'Charging Region')
grid on

% Distance Travelled
nexttile
plot(t, distance_km, 'b', 'LineWidth', 1.5)
xlabel('Time (s)')
ylabel('Distance (Km)')
title('Distance Travelled')
grid on

% Torque
nexttile
plot(t, Torque, 'g')
xlabel('Time (s)')
ylabel('Torque (Nm)')
title('Torque vs Time')
grid on

% Power
nexttile
plot(t(drive_idx), Power(drive_idx), 'b', 'LineWidth', 1.5) 
hold on
plot(t(regen_idx), Power(regen_idx), 'r', 'LineWidth', 1.5) 
hold on
yline(0,'--k')
hold on
xlabel('Time (s)')
ylabel('Power (W)')
title('Power vs Time (Regeneration Highlighted)')
legend('Driving (Discharging)', 'Regenerative Braking(Charging)')
grid on

% Current
nexttile
plot(t(drive_idx), I(drive_idx), 'b', 'LineWidth', 1.5)
hold on;
plot(t(regen_idx), I(regen_idx), 'r', 'LineWidth', 1.5)
xlabel('Time (s)')
ylabel('Current (A)')
title('Battery Current vs Time')
legend('Discharging', 'Charging')
grid on

% Voltage
nexttile
plot(t, V_oc, 'g', 'LineWidth', 1.5)
hold on
plot(t, V, 'b--', 'LineWidth', 1.5)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Battery Voltage vs Time')
legend('Open Circuit Voltage (V_{oc})', 'Terminal Voltage (V)')
grid on

% Energy Consumption
nexttile
plot(t, Energy_cons_wh, 'r', 'LineWidth', 1.5)
hold on
yline(0,'--')
xlabel('Time (s)')
ylabel('Energy (Wh)')
title('Net Battery Energy (Consumption + Regeneration)')
grid on

% Range
nexttile
plot(t, Range_km, 'b', 'LineWidth', 1.5)
xlabel('Time (s)')
ylabel('Range (km)')
title('Estimated Remaining Range')
grid on


% RPM
nexttile
plot(t, RPM, 'c', 'LineWidth', 1.5)
xlabel('Time (s)')
ylabel('RPM')
title('Wheel RPM')
grid on