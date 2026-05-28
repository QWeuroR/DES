clear; clc; close all;
f = 0.1:0.05:5.5;
A = ones(size(f));
iter = 1;

% Load the optimized parameters
load('best_parameters_1.mat');

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

% Set Manual Switch to the second position ('0' means second/bottom input)
set_param([ModelName '/Manual Switch'], 'sw', '0');

for f1 = f
    set_param('SynchronousMachine/Signal Generator', "Frequency", num2str(f1))
    % set_param('SynchronousMachine', 'SimulationCommand', 'update')  % Force recompile
    out = sim('SynchronousMachine');

    Pe = out.Pe.Data - 0.8;

    Au = 0.01;
    [pks, loc] = findpeaks(Pe, 'MinPeakHeight', 0.001);
    
    if isempty(pks)
        fprintf('Freq: %.2f - NO PEAKS FOUND\n', f1);
        Ay = 0;
    else
        Ay = pks(end);
        fprintf('Freq: %.2f - pks: %s, Ay: %.6f, A: %.6f\n', f1, num2str(pks'), Ay, Ay/Au);
    end

    A(iter) = Ay/Au;

    iter = iter + 1;
end

plot(f,A);