% This script allows you to explore the various energy consumption models for the Kia Niro EV 
% (Model Year 2023), as discussed in the research article. The models include:
%
% 1. NARXP (Nonlinear AutoRegressive with eXogenous inputs in Prediction configuration)
% 2. NARXS (Nonlinear AutoRegressive with eXogenous inputs in Simulation configuration)
% 3. LSTM (Long Short-Term Memory)
% 4. NN (single-layer feedforward Neural Network)
% 5. NNP (single-layer feedforward Neural Network in Prediction configuration)
% 6. NNS (single-layer feedforward Neural Network in Simulation configuration) 
%
% The model inputs are the motor torque (Nm) and the vehicle speed (m/s), and the model output is the 
% electric power (kW) from the battery pack.
%
% This script uses on-road trip data for the Kia Niro EV, collected by the Future Mobility  
% Lab at the University of Southampton. Data was recorded over four days on various routes, including 
% Southampton to Chilworth, Alderbury, Basingstoke, Portsmouth, Beaulieu, Christchurch, and Bournemouth.
%
% The script was developed with the following MATLAB installation:
% -----------------------------------------------------------------------------------------------------
% MATLAB Version: 23.2.0.2515942 (R2023b) Update 7
% Operating System: Microsoft Windows 10 Enterprise Version 10.0 (Build 19045)
% Java Version: Java 1.8.0_202-b08 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode
% -----------------------------------------------------------------------------------------------------
% Deep Learning Toolbox                                 Version 23.2        (R2023b)
% Statistics and Machine Learning Toolbox               Version 23.2        (R2023b)
% System Identification Toolbox                         Version 23.2        (R2023b)
% -----------------------------------------------------------------------------------------------------
% It may or may not be compatible with other MATLAB versions.
%
% © School of Engineering, University of Southampton, UK.

clear all; % Clears the base workspace
clc;       % Clears the command window
close all; % Closes all figures

% Explore the existing models
disp('Kia Niro EV Energy Consumption Models');
disp('-------------------------------------');
disp('1. NARXP (Nonlinear AutoRegressive with eXogenous inputs in Prediction configuration)');
disp('2. NARXS (Nonlinear AutoRegressive with eXogenous inputs in Simulation configuration)');
disp('3. LSTM (Long Short-Term Memory)');
disp('4. NN (single-layer feedforward Neural Network)');
disp('5. NNP (single-layer feedforward Neural Network in Prediction configuration)');
disp('6. NNS (single-layer feedforward Neural Network in Simulation configuration)');
disp(' '); % New line space

model_choice = getValidInput('Select a model (1-6): ', 1:6);
disp(' '); % New line space

% Display the selected model's results
switch model_choice
    case 1
        disp('NARXP model results...');
        evalin('base', 'run(''Model_Result_Scripts/NARXP_result.m'')');
    case 2
        disp('NARXS model results...');
        evalin('base', 'run(''Model_Result_Scripts/NARXS_result.m'')');
    case 3
        disp('LSTM model results...');
        evalin('base', 'run(''Model_Result_Scripts/LSTM_result.m'')');
    case 4
        disp('NN model results...');
        evalin('base', 'run(''Model_Result_Scripts/NN_result.m'')');
    case 5
        disp('NNP model results...');
        evalin('base', 'run(''Model_Result_Scripts/NNP_result.m'')');
    case 6
        disp('NNS model results...');
        evalin('base', 'run(''Model_Result_Scripts/NNS_result.m'')');
end

disp('Model and result are loaded into the workspace.');
disp('Exiting...');

% Function to handle valid input with retries
function result = getValidInput(prompt, validValues)
    max_attempts = 3;
    attempt = 0;
    % Initialize result to avoid storing incorrect input
    result = []; 
    while attempt < max_attempts
        temp = input(prompt);
        if isa(validValues, 'function_handle')
            isValid = validValues(temp);
        else
            isValid = ismember(temp, validValues);
        end
        if isValid
            result = temp; % Only store the result if valid
            return;
        else
            attempt = attempt + 1;
            disp('Invalid input. Please try again.');
            if attempt == max_attempts
                disp('Too many incorrect attempts. Exiting...');
                return; % Exit script
            end
        end
    end
end