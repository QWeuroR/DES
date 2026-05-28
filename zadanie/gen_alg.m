clear; close all; clc;

%% GA Parameters
PopSize = 35;           % Population size
NumGenerations = 50;   % Number of generations
MutationRate = 0.3;       % Mutation strength (1-10)
CrossoverPoints = 2;    % Number of crossover points (1-4)

% Define search space: [lower_limits; upper_limits]
% Genes: T1, T2, Kpe, Kp, Ki
Space = [0.001, 0.001, 0.001, 0.001, 0.001;      % Lower limits
         5.0,   5.0,   0.8,   5.0,   5.0];    % Upper limits

%% Initialize
% Generate initial random population
Population = genrpop(PopSize, Space);

% Amplitude for mutations (same range for each gene)
MutationAmp = 0.5 * (Space(2,:) - Space(1,:));

% History for tracking best fitness
HistoryFit = zeros(NumGenerations, 1);

%% Initialize parallel pool with limited workers
poolobj = gcp('nocreate');
if isempty(poolobj)
    parpool('local', 5);  % Change 6 to 8 if preferred
end

%% Main GA Loop
for gen = 1:NumGenerations
    fprintf("gen: %d\n",gen);

    % Calculate fitness for current population
    Fitness = fitness_function(Population);
    
    % Store best fitness of this generation
    HistoryFit(gen) = min(Fitness);
    
    % Display progress
    fprintf('Generation %d: Best Fitness = %.6f\n', gen, HistoryFit(gen));
    
    % Selection: select best individuals
    % Nums = [num_copies_best1, num_copies_best2, ...]
    Nums = [2, 2, 1]; 
    best = selbest(Population, Fitness, Nums);
    
    % Crossover: create new individuals from selected ones
    mut_best = crossov(best, CrossoverPoints, 1);
    
    % Mutation: introduce random variations
    Population = mutx(Population, MutationRate, Space);
    mut_best = muta(mut_best,MutationRate, MutationAmp, Space);
    best_size = size(best, 1);
    Population(1:best_size, :) = mut_best; 
    Population(best_size+1:best_size*2, :) = best;  
    
end

%% Extract best solution
FinalFitness = fitness_function(Population);
[BestFit, BestIdx] = min(FinalFitness);
BestPop = Population(BestIdx, :);

%% Display Results
fprintf('\n========== FINAL RESULTS ==========\n');
fprintf('Best Fitness Value: %.6f\n', BestFit);
fprintf('T1  = %.4f\n', BestPop(1));
fprintf('T2  = %.4f\n', BestPop(2));
fprintf('Kpe = %.4f\n', BestPop(3));
fprintf('Kp  = %.4f\n', BestPop(4));
fprintf('Ki  = %.4f\n', BestPop(5));

%% Save Best Parameters
% Extract the individual values
T1  = BestPop(1);
T2  = BestPop(2);
Kpe = BestPop(3);
Kp  = BestPop(4);
Ki  = BestPop(5);

% Save them to a .mat file
save('best_parameters.mat', 'T1', 'T2', 'Kpe', 'Kp', 'Ki');
fprintf('Best parameters successfully saved to "best_parameters.mat".\n');

%% Plot convergence
figure;
plot(HistoryFit, 'b-', 'LineWidth', 2);
xlabel('Generation');
ylabel('Best Fitness');
title('GA Convergence');
grid on;


%% Fitness Function
% Run Simulink simulation and calculate fitness
function[Fit] = fitness_function(Pop)
    
    [lpop, ~] = size(Pop);
    Fit = zeros(lpop, 1);
    
    ModelName = 'SynchronousMachine'; 
    load_system(ModelName); % Ensure the model is loaded in memory to read params
    
    % 1. Create an array of SimulationInput objects
    simIn(1:lpop) = Simulink.SimulationInput(ModelName);
    
    % Get the current array for the 'reg' parameter in the HTG block
    % It is typically a string like '[0.05 1.163 0.105 0 0.01]'
    baseRegStr = get_param([ModelName '/HTG'], 'reg');
    baseReg = str2num(baseRegStr); % Convert to numeric array
    
    % 2. Pre-configure block parameters for all individuals
    for i = 1:lpop
        T1  = Pop(i, 1);
        T2  = Pop(i, 2);
        Kpe = Pop(i, 3);
        Kp  = Pop(i, 4);
        Ki  = Pop(i, 5);
        
        simIn(i) = simIn(i).setBlockParameter([ModelName '/pss'], 'T1', num2str(T1));
        simIn(i) = simIn(i).setBlockParameter([ModelName '/pss'], 'T2', num2str(T2));
        simIn(i) = simIn(i).setBlockParameter([ModelName '/pss'], 'Kpe', num2str(Kpe));
        
        % Update the specific elements for the HTG 'reg' vector
        indivReg = baseReg;      % copy the base array
        indivReg(2) = Kp;        % update 2nd parameter
        indivReg(3) = Ki;        % update 3rd parameter
        
        % Convert back to a matrix string e.g. '[0.05 5.0 2.5 0 0.01]'
        simIn(i) = simIn(i).setBlockParameter([ModelName '/HTG'], 'reg', mat2str(indivReg));
    end
    
    % 3. Run all simulations in parallel using parsim
    simOut = parsim(simIn, 'ShowProgress', 'off', 'UseFastRestart', 'on');
    
    % 4. Evaluate fitness from the parallel simulation results
    for i = 1:lpop
        if ~isempty(simOut(i).ErrorMessage)
            % If simulation fails, assign large penalty
            Fit(i) = 1e6;
            fprintf('Error for individual %d: %s\n', i, simOut(i).ErrorMessage);
        else
            % ==============================================
            % 1. Terminal Voltage (Vt) Error Calculation
            % ==============================================
            output_Vt = simOut(i).Vt.Data;
            desired_Vt = simOut(i).V_ref.Data;
            
            % Calculate error (AIE for voltage)
            error_Vt = output_Vt - desired_Vt;
            Fit_Vt = sum(abs(error_Vt));
            
            % ==============================================
            % 2. Electrical Power (Pe) Error Calculation
            % ==============================================
            output_Pe = simOut(i).Pe.Data;
            desired_Pe = 220 / 273;  % Reference steady-state power
            
            % Calculate error (AIE for power)
            error_Pe = output_Pe - desired_Pe;
            Fit_Pe = sum(abs(error_Pe));
            
            % ==============================================
            % 3. Total Combined Fitness
            % ==============================================
            % You can configure weights here. Currently it's 1:1.
            weight_Vt = 1.0; 
            weight_Pe = 1.0; 
            
            Fit(i) = (weight_Vt * Fit_Vt) + (weight_Pe * Fit_Pe);
        end
    end
end
