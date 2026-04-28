# EV Powertrain Simulation Using MATLAB

## Project Overview

This project implements an Electric Vehicle (EV) Powertrain model in MATLAB to simulate vehicle longitudinal dynamics and battery energy usage.

The model estimates vehicle behavior by calculating:

* Vehicle speed response
* Driving and resistive forces
* Motor torque
* Power consumption
* Battery State of Charge (SOC)
* Regenerative braking behavior

The project also includes:

* Dynamic throttle input
* Aerodynamic drag modeling
* Rolling resistance modeling
* Battery SOC estimation
* Energy recovery using regenerative braking
* Performance visualization using MATLAB plots

## Overview

This project presents a MATLAB-based simulation of an Electric Vehicle (EV) Powertrain system.

The model simulates vehicle longitudinal dynamics by calculating driving force, resistive forces, velocity response, motor torque, power consumption, battery State of Charge (SOC), and regenerative braking.

The project is designed to provide a simplified understanding of EV physics and energy flow using mathematical equations and numerical simulation.

---

## Objective

The objective of this project is to:

* Simulate EV motion using physics-based equations
* Understand force balance in an electric vehicle
* Calculate motor torque and power demand
* Track battery State of Charge (SOC)
* Implement Regenerative Braking logic
* Visualize EV performance through MATLAB plots

---

## Features

* MATLAB-based EV longitudinal dynamics model
* Time-varying throttle input
* Rolling resistance modeling
* Aerodynamic drag modeling
* Driving force calculation
* Vehicle acceleration and velocity update
* Motor torque estimation
* Power consumption analysis
* Battery SOC tracking
* Regenerative braking implementation
* Multi-plot visualization using 'tiledlayout'

---

## Mathematical Model

### Driving Force

F_{drive} = (m*a);


### Rolling Resistance

F_{roll} = (m*g*Cr)


### Aerodynamic Drag

F_{drag} = [0.5*rho*A*Cd*(v^2)]


### Net Force

F_{total} = [F_{drive} - F_{roll} - F_{drag}]


### Vehicle Acceleration

a_{actual} = [F_{total}/m]


### Vehicle Velocity Update

velocity_{new} = [velocity_{old} + a_{actual}*dt]


### Motor Torque

Torque = [F_{drive}*R]


### Motor Power

Power = [F_{drive}*velocity]


### Battery SOC Update

SOC(i+1) = [SOC(i) - {(I(i)*dt)/(Capacity*3600)}*100]


---

## Regenerative Braking

Regenerative braking is implemented when the vehicle enters braking mode.

When:

F_{drive(i)} < 0

The motor behaves like a generator.

Recovered energy is sent back to the battery.

Regen efficiency assumed: 65%

---

## Parameters Used

| Parameter                      | Value | Unit  |
| ------------------------------ | ----- | ----- |
| Vehicle Mass                   | 1200  | kg    |
| Gravity                        | 9.81  | m/s²  |
| Rolling Resistance Coefficient | 0.01  | -     |
| Air Density                    | 1.2   | kg/m³ |
| Drag Coefficient               | 0.3   | -     |
| Frontal Area                   | 2.2   | m²    |
| Wheel Radius                   | 0.3   | m     |
| Battery Capacity               | 50    | Ah    |
| Time Step                      | 0.1   | s     |

---

## Simulation Outputs

The simulation generates the following results:

1. Speed vs Time
2. Distance Travelled vs SOC
3. SOC vs Time
4. Distance Travelled vs Time
5. Torque vs Time
6. Power vs Time
7. Current vs Time
8. Voltage vs Time
9. Energy Consumption vs Time
10. Range vs Time
11. RPM vs Time

---

## MATLAB Concepts Used

* Array pre-allocation
* For loops
* Conditional statements
* Logical indexing
* Numerical integration
* Plotting using tiledlayout
* Dynamic variable update

---

## Folder Structure

```text
EV-Powertrain-Simulation/
│
├── ev_powertain_main_code.m
├── README.md
├── Results/
│   ├── speed_vs_time.png
│   ├── soc_vs_distance.png
│   ├── soc_vs_time.png
│   ├── distance_vs_time.png
│   ├── torque_vs_time.png
│   ├── power_vs_time.png
│   ├── current_vs_time.png
│   ├── voltage_vs_time.png
│   ├── energy_vs_time.png
│   ├── range_vs_time.png
│   └── rpm_vs_time.png
├── Screenshots/
│   ├── output_plot.png
└── EV_Powertain_Project_Report.pdf
```

---

## Learning Outcomes

Through this project, the following concepts are learned:

* EV longitudinal dynamics
* Vehicle force balance
* Motor torque generation
* Power flow in EV systems
* Battery SOC tracking
* Regenerative braking concept
* MATLAB-based simulation techniques

---

## Future Improvements

Possible upgrades:

* Battery voltage variation model
* Motor efficiency model
* Gear ratio implementation
* Road slope simulation
* Range estimation
* Real drive cycle input
* GUI dashboard

---

## Author

Ayush Kumar
Electrical Engineering Student
EV Powertrain MATLAB Simulation Project

---

## License

This project is open-source and intended for educational and learning purposes.
