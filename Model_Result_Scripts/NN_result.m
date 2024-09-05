% Load the trained NN model with required dataset
load("../Existing_Models/NN_model.mat");
load("../Existing_Models/All_Trips_Dataset_2_Inputs_1_Output.mat");

% Prepare datasets for each trip
% Trip 1
Trip_1_data = [Trip_1_M_Torque_final(:,2) Trip_1_Speed_final(:,2) Trip_1_kW_final(:,2)];
Trip_1_data = array2table(Trip_1_data);
Trip_1_data.Properties.VariableNames = {'Torquenm';
                              'Speedms';
                              'Powerkw'};

% Trip 2
Trip_2_data = [Trip_2_M_Torque_final(:,2) Trip_2_Speed_final(:,2) Trip_2_kW_final(:,2)];
Trip_2_data = array2table(Trip_2_data);
Trip_2_data.Properties.VariableNames = {'Torquenm';
                              'Speedms';
                              'Powerkw'};

% Trip 3
Trip_3_data = [Trip_3_M_Torque_final(:,2) Trip_3_Speed_final(:,2) Trip_3_kW_final(:,2)];
Trip_3_data = array2table(Trip_3_data);
Trip_3_data.Properties.VariableNames = {'Torquenm';
                              'Speedms';
                              'Powerkw'};

% Trip 4
Trip_4_data = [Trip_4_M_Torque_final(:,2) Trip_4_Speed_final(:,2) Trip_4_kW_final(:,2)];
Trip_4_data = array2table(Trip_4_data);
Trip_4_data.Properties.VariableNames = {'Torquenm';
                              'Speedms';
                              'Powerkw'};

% Predict the output using the trained NN model for Trip 1
Trip_1_y_hat = predict(NN,Trip_1_data);

% Actual output for comparison
Trip_1_y_actual = [Trip_1_kW_final(:,2)];

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
Trip_2_y_hat = predict(NN,Trip_2_data);
Trip_2_y_actual = [Trip_2_kW_final(:,2)];

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
Trip_3_y_hat = predict(NN,Trip_3_data);
Trip_3_y_actual = [Trip_3_kW_final(:,2)];

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
Trip_4_y_hat = predict(NN,Trip_4_data);
Trip_4_y_actual = [Trip_4_kW_final(:,2)];

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