% Load the trained NARXP (NARX in prediction configuration) model with required dataset
load("../Existing_Models/NARXP_model.mat");
load("../Existing_Models/All_Trips_Dataset_2_Inputs_1_Output.mat");

% Define the sampling time of the measured dataset
T_sample = 0.22;

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

% Create the identification dataset for Trip 1
Identification_dataset = iddata(Trip_1_output, [Trip_1_inputs(:,2) Trip_1_inputs(:,1)], T_sample);                                                      
Identification_dataset.OutputUnit = 'kW';
Identification_dataset.InputUnit = {'m/s' 'Nm'};
Identification_dataset.OutputName = 'Electric Power';
Identification_dataset.InputName = {'Speed' 'Motor Torque'};

% Predict the output using the identified NARXP model for Trip 1
predictOpt = predictOptions('InitialCondition','z');
Trip_1_estimated_y = predict(NARXP, Identification_dataset, 1, predictOpt);
Trip_1_y_hat = Trip_1_estimated_y.OutputData;

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

% Create validation datasets for Trips 2, 3, and 4, and perform similar operations

% Trip 2 Validation
Validation_dataset_1 = iddata(Trip_2_output, [Trip_2_inputs(:,2) Trip_2_inputs(:,1)], T_sample);                                                      
Validation_dataset_1.OutputUnit = 'kW';
Validation_dataset_1.InputUnit = {'m/s' 'Nm'};
Validation_dataset_1.OutputName = 'Electric Power';
Validation_dataset_1.InputName = {'Speed' 'Motor Torque'};

Trip_2_estimated_y = predict(NARXP, Validation_dataset_1, 1, predictOpt);
Trip_2_y_hat = Trip_2_estimated_y.OutputData;
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
Validation_dataset_2 = iddata(Trip_3_output, [Trip_3_inputs(:,2) Trip_3_inputs(:,1)], T_sample);                                                      
Validation_dataset_2.OutputUnit = 'kW';
Validation_dataset_2.InputUnit = {'m/s' 'Nm'};
Validation_dataset_2.OutputName = 'Electric Power';
Validation_dataset_2.InputName = {'Speed' 'Motor Torque'};

Trip_3_estimated_y = predict(NARXP, Validation_dataset_2, 1, predictOpt);
Trip_3_y_hat = Trip_3_estimated_y.OutputData;
Trip_3_y_actual = Trip_3_output;

% Calculate the MSE for Trip 3
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
Validation_dataset_3 = iddata(Trip_4_output, [Trip_4_inputs(:,2) Trip_4_inputs(:,1)], T_sample);                                                      
Validation_dataset_3.OutputUnit = 'kW';
Validation_dataset_3.InputUnit = {'m/s' 'Nm'};
Validation_dataset_3.OutputName = 'Electric Power';
Validation_dataset_3.InputName = {'Speed' 'Motor Torque'};

Trip_4_estimated_y = predict(NARXP, Validation_dataset_3, 1, predictOpt);
Trip_4_y_hat = Trip_4_estimated_y.OutputData;
Trip_4_y_actual = Trip_4_output;

% Calculate the MSE for Trip 4
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