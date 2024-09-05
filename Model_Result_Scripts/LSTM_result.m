% Load the trained LSTM model with required dataset
load("../Existing_Models/LSTM_model.mat");
load("../Existing_Models/All_Trips_Dataset_2_Inputs_1_Output.mat");

% Prepare input and output datasets for each trip
% Trip 1
Trip_1_inputs = [Trip_1_M_Torque_final(:,2) Trip_1_Speed_final(:,2)];
Trip_1_output = [Trip_1_kW_final(:,2)];

% Trip 2
Trip_2_inputs = [Trip_2_M_Torque_final(:,2) Trip_2_Speed_final(:,2)];
Trip_2_output = [Trip_2_kW_final(:,2)];

% Trip 3
Trip_3_inputs = [Trip_3_M_Torque_final(:,2) Trip_3_Speed_final(:,2)];
Trip_3_output = [Trip_3_kW_final(:,2)];

% Trip 4
Trip_4_inputs = [Trip_4_M_Torque_final(:,2) Trip_4_Speed_final(:,2)];
Trip_4_output = [Trip_4_kW_final(:,2)];

% Initialize standardized inputs and outputs for each trip
Trip_1_inputs_std = Trip_1_inputs;
Trip_1_output_std = Trip_1_output;
Trip_2_inputs_std = Trip_2_inputs;
Trip_2_output_std = Trip_2_output;
Trip_3_inputs_std = Trip_3_inputs;
Trip_3_output_std = Trip_3_output;
Trip_4_inputs_std = Trip_4_inputs;
Trip_4_output_std = Trip_4_output;

% Get the number of rows and columns for Trip 1 inputs
[rs cs] = size(Trip_1_inputs);

% Initialize mean and standard deviation vectors for input standardization
mu_Trip_1_inputs= zeros(1,cs);
sig_Trip_1_inputs= ones(1,cs);

% Standardize inputs for all trips based on the mean and standard deviation of Trip 1 inputs
for i=1:cs
     mu_Trip_1_inputs(i)=mean(Trip_1_inputs(:,i));
     sig_Trip_1_inputs(i)=std(Trip_1_inputs(:,i));
     Trip_1_inputs_std(:,i)= (Trip_1_inputs(:,i)-mu_Trip_1_inputs(i))/sig_Trip_1_inputs(i);
     Trip_2_inputs_std(:,i)= (Trip_2_inputs(:,i)-mu_Trip_1_inputs(i))/sig_Trip_1_inputs(i);
     Trip_3_inputs_std(:,i)= (Trip_3_inputs(:,i)-mu_Trip_1_inputs(i))/sig_Trip_1_inputs(i);
     Trip_4_inputs_std(:,i)= (Trip_4_inputs(:,i)-mu_Trip_1_inputs(i))/sig_Trip_1_inputs(i);
end

% Get the number of rows and columns for Trip 1 outputs
[rs_1 cs_1] = size(Trip_1_output);

% Initialize mean and standard deviation vectors for output standardization
mu_Trip_1_output= zeros(1,cs_1);
sig_Trip_1_output= ones(1,cs_1);

% Standardize outputs for all trips based on the mean and standard deviation of Trip 1 outputs
for i=1:cs_1
    mu_Trip_1_output(i)=mean(Trip_1_output(:,i));
    sig_Trip_1_output(i)=std(Trip_1_output(:,i));
    Trip_1_output_std(:,i)= (Trip_1_output(:,i)-mu_Trip_1_output(i))/sig_Trip_1_output(i);
    Trip_2_output_std(:,i)= (Trip_2_output(:,i)-mu_Trip_1_output(i))/sig_Trip_1_output(i);
    Trip_3_output_std(:,i)= (Trip_3_output(:,i)-mu_Trip_1_output(i))/sig_Trip_1_output(i);
    Trip_4_output_std(:,i)= (Trip_4_output(:,i)-mu_Trip_1_output(i))/sig_Trip_1_output(i);
end

% Set parameters for prediction
predictionStart = 1;
predictionStep = length(Trip_1_output) - 1;
numExperiment = length(Trip_1_output) - predictionStep;

% Convert standardized inputs and outputs to cell arrays for Trip 1
Trip_1_inputs_cell = cell(1, numExperiment);
Trip_1_output_cell = cell(1, numExperiment);

% Populate the cell arrays with sliding window approach
for i=1:numExperiment
    Trip_1_inputs_cell{i} = Trip_1_inputs_std(i:i+predictionStep,:)';
    Trip_1_output_cell{i} = Trip_1_output_std(i:i+predictionStep,:)';
end

% Prepare the standardized inputs for the LSTM model
Trip_1_inputs_cell_std      = cell(1,1);
Trip_1_inputs_cell_std{1}   = Trip_1_inputs_std(predictionStart:predictionStart+predictionStep,:)';

% Predict the standardized output using the trained LSTM model for Trip 1
Trip_1_output_std_cell      = predict(LSTM,Trip_1_inputs_cell_std);

% Convert the standardized predicted output back to original scale
Trip_1_y_hat_std = [cell2mat(Trip_1_output_std_cell)]';
Trip_1_y_hat(:,1) =(Trip_1_y_hat_std(:,1).*sig_Trip_1_output(1))+mu_Trip_1_output(1);

% Actual output for comparison
Trip_1_y_actual = Trip_1_output;

% Calculate the Mean Squared Error (MSE) for Trip 1
Trip_1_mse = goodnessOfFit(Trip_1_y_hat, Trip_1_y_actual, 'MSE');

% Plot the actual vs estimated output for Trip 1
figure('Name', 'Trip 1 Identification Dataset', 'NumberTitle', 'off');
figure(1);
plot(Trip_1_y_actual)
hold on
plot(Trip_1_y_hat, 'color', "red", "LineStyle", "--")
hold off
legend('Actual', 'Estimated')
xlabel("Time (Second)")
ylabel("Power (kW)")
mstr = ['MSE = ', sprintf('%.4f', Trip_1_mse)];
annotation('textbox', [.15 0.9 0 0], 'string', mstr, 'FitBoxToText', 'on', 'EdgeColor', 'black')

% Repeat the same process for validation datasets (Trips 2, 3, and 4)

% Trip 2 Validation
predictionStep  = length(Trip_2_output) - 1;
numExperiment   = length(Trip_2_output) - predictionStep;

Trip_2_inputs_cell = cell(1, numExperiment); 
Trip_2_output_cell = cell(1, numExperiment);

[rs_2 cs_2] = size(Trip_2_output);

for i=1:numExperiment
    Trip_2_inputs_cell{i} = Trip_2_inputs_std(i:i+predictionStep,:)';
    Trip_2_output_cell{i} = Trip_2_output_std(i:i+predictionStep,:)';    
end

Trip_2_inputs_cell_std      = cell(1,1);
Trip_2_inputs_cell_std{1}   = Trip_2_inputs_std(predictionStart:predictionStart+predictionStep,:)';
Trip_2_output_cell_std      = predict(LSTM,Trip_2_inputs_cell_std);

Trip_2_y_hat = zeros(rs_2,cs_2);

Trip_2_y_hat_std = [cell2mat(Trip_2_output_cell_std)]'; 
Trip_2_y_hat(:,1) =(Trip_2_y_hat_std(:,1).*sig_Trip_1_output(1))+mu_Trip_1_output(1);
Trip_2_y_actual = Trip_2_output;

% Calculate the MSE for Trip 2
Trip_2_mse = goodnessOfFit(Trip_2_y_hat, Trip_2_y_actual, 'MSE');

% Plot the actual vs estimated output for Trip 2
figure('Name', 'Trip 2 Validation Dataset', 'NumberTitle', 'off');
figure(2);
plot(Trip_2_y_actual)
hold on
plot(Trip_2_y_hat, 'color', "red", "LineStyle", "--")
hold off
legend('Actual', 'Estimated')
xlabel("Time (Second)")
ylabel("Power (kW)")
mstr = ['MSE = ', sprintf('%.4f', Trip_2_mse)];
annotation('textbox', [.15 0.9 0 0], 'string', mstr, 'FitBoxToText', 'on', 'EdgeColor', 'black')

% Trip 3 Validation
predictionStep  = length(Trip_3_output) - 1;
numExperiment   = length(Trip_3_output) - predictionStep;

Trip_3_inputs_cell = cell(1, numExperiment); 
Trip_3_output_cell = cell(1, numExperiment);

[rs_3 cs_3] = size(Trip_3_output);

for i=1:numExperiment
    Trip_3_inputs_cell{i} = Trip_3_inputs_std(i:i+predictionStep,:)';
    Trip_3_output_cell{i} = Trip_3_output_std(i:i+predictionStep,:)';    
end

Trip_3_inputs_cell_std      = cell(1,1);
Trip_3_inputs_cell_std{1}   = Trip_3_inputs_std(predictionStart:predictionStart+predictionStep,:)';
Trip_3_output_cell_std      = predict(LSTM,Trip_3_inputs_cell_std);

Trip_3_y_hat = zeros(rs_3,cs_3);

Trip_3_y_hat_std = [cell2mat(Trip_3_output_cell_std)]'; 
Trip_3_y_hat(:,1) =(Trip_3_y_hat_std(:,1).*sig_Trip_1_output(1))+mu_Trip_1_output(1);
Trip_3_y_actual = Trip_3_output;

% Calculate the MSE for Trip 2
Trip_3_mse = goodnessOfFit(Trip_3_y_hat, Trip_3_y_actual, 'MSE');

% Plot the actual vs estimated output for Trip 3
figure('Name', 'Trip 3 Validation Dataset', 'NumberTitle', 'off');
figure(3);
plot(Trip_3_y_actual)
hold on
plot(Trip_3_y_hat, 'color', "red", "LineStyle", "--")
hold off
legend('Actual', 'Estimated')
xlabel("Time (Second)")
ylabel("Power (kW)")
mstr = ['MSE = ', sprintf('%.4f', Trip_3_mse)];
annotation('textbox', [.15 0.9 0 0], 'string', mstr, 'FitBoxToText', 'on', 'EdgeColor', 'black')

% Trip 4 Validation
predictionStep  = length(Trip_4_output) - 1;
numExperiment   = length(Trip_4_output) - predictionStep;

Trip_4_inputs_cell = cell(1, numExperiment); 
Trip_4_output_cell = cell(1, numExperiment);

[rs_4 cs_4] = size(Trip_4_output);

for i=1:numExperiment
    Trip_4_inputs_cell{i} = Trip_4_inputs_std(i:i+predictionStep,:)';
    Trip_4_output_cell{i} = Trip_4_output_std(i:i+predictionStep,:)';    
end

Trip_4_inputs_cell_std      = cell(1,1);
Trip_4_inputs_cell_std{1}   = Trip_4_inputs_std(predictionStart:predictionStart+predictionStep,:)';
Trip_4_output_cell_std      = predict(LSTM,Trip_4_inputs_cell_std);

Trip_4_y_hat = zeros(rs_4,cs_4);

Trip_4_y_hat_std = [cell2mat(Trip_4_output_cell_std)]'; 
Trip_4_y_hat(:,1) =(Trip_4_y_hat_std(:,1).*sig_Trip_1_output(1))+mu_Trip_1_output(1);
Trip_4_y_actual = Trip_4_output;

% Calculate the MSE for Trip 2
Trip_4_mse = goodnessOfFit(Trip_4_y_hat, Trip_4_y_actual, 'MSE');

% Plot the actual vs estimated output for Trip 4
figure('Name', 'Trip 4 Validation Dataset', 'NumberTitle', 'off');
figure(4);
plot(Trip_4_y_actual)
hold on
plot(Trip_4_y_hat, 'color', "red", "LineStyle", "--")
hold off
legend('Actual', 'Estimated')
xlabel("Time (Second)")
ylabel("Power (kW)")
mstr = ['MSE = ', sprintf('%.4f', Trip_4_mse)];
annotation('textbox', [.15 0.9 0 0], 'string', mstr, 'FitBoxToText', 'on', 'EdgeColor', 'black')

% Calculate the average MSE across all validation trips
Average_Validation_mse = (Trip_2_mse + Trip_3_mse + Trip_4_mse) / 3;

% Store the results in a table
Results = table([Trip_1_mse], [Trip_2_mse], [Trip_3_mse], [Trip_4_mse], [Average_Validation_mse],...
    'VariableNames', {'Trip 1', 'Trip 2', 'Trip 3', 'Trip 4', 'Validation Average'}, 'RowName', {'MSE'});

% Display the results table in the Command Window
disp(Results);