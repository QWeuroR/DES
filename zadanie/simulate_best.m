clear all; %close all; clc;

% Load the best parameters from the GA script
% This loads T1, T2, Kpe, Kp, Ki into the workspace
load('best_parameters.mat');

% Define model name and load it into memory
ModelName = 'SynchronousMachine';
load_system(ModelName);

% Set parameters in PSS block
set_param([ModelName '/pss'], 'T1', num2str(T1));
set_param([ModelName '/pss'], 'T2', num2str(T2));
set_param([ModelName '/pss'], 'Kpe', num2str(Kpe));

% Get current HTG reg array and update Kp and Ki
baseRegStr = get_param([ModelName '/HTG'], 'reg');
baseReg = str2num(baseRegStr);
baseReg(2) = Kp;
baseReg(3) = Ki;

% Set parameters in HTG block
set_param([ModelName '/HTG'], 'reg', mat2str(baseReg));

% Run the simulation
disp('Running simulation with optimized parameters...');
simOut = sim(ModelName);

% Extract simulation data
t = simOut.tout;
Vt = simOut.Vt.Data;
V_ref = simOut.V_ref.Data;
Pe = simOut.Pe.Data;

% Plot the results
figure('Name', 'Optimized Parameters Simulation');

subplot(2,1,1);
plot(t, Vt, 'b-', 'LineWidth', 1.5); hold on;
plot(t, V_ref, 'r--', 'LineWidth', 1.5);
title('Terminal Voltage (V_t) vs Reference (V_{ref})');
xlabel('Time [s]');
ylabel('Voltage [pu]');
legend('V_t', 'V_{ref}', 'Location', 'best');
grid on;

subplot(2,1,2);
plot(t, Pe, 'g-', 'LineWidth', 1.5);
title('Electrical Power (P_e)');
xlabel('Time [s]');
ylabel('Power [pu]');
grid on;
