% Load the trained NNS model (NN in Simulation configuration) with required dataset
load("../Existing_Models/NNS_model.mat");
load("../Existing_Models/All_Trips_Dataset_2_Inputs_1_Output.mat");
load("../Existing_Models/All_Trips_Past_Dataset.mat");

% Prepare datasets with current inputs, past inputs and past outputs values (same order as NARX models) for each trip
% Trip 1
Trip_1_data = [Trip_1_M_Torque_final(:,2) Trip_1_M_Torque_final_k_minus_1 Trip_1_M_Torque_final_k_minus_2 Trip_1_Speed_final(:,2) Trip_1_Speed_final_k_minus_1 Trip_1_Speed_final_k_minus_2 Trip_1_kW_final_k_minus_1 Trip_1_kW_final_k_minus_2 Trip_1_kW_final_k_minus_3 Trip_1_kW_final(:,2)];
Trip_1_data = array2table(Trip_1_data);
Trip_1_data.Properties.VariableNames = {'Torquenm';
                              'Torquenm1';
                              'Torquenm2';
                              'Speedms';
                              'Speedms1';
                              'Speedms2';
                              'Powerkw1';
                              'Powerkw2';
                              'Powerkw3';
                              'Powerkw'};

% Trip 2
Trip_2_data = [Trip_2_M_Torque_final(:,2) Trip_2_M_Torque_final_k_minus_1 Trip_2_M_Torque_final_k_minus_2 Trip_2_Speed_final(:,2) Trip_2_Speed_final_k_minus_1 Trip_2_Speed_final_k_minus_2 Trip_2_kW_final_k_minus_1 Trip_2_kW_final_k_minus_2 Trip_2_kW_final_k_minus_3 Trip_2_kW_final(:,2)];
Trip_2_data = array2table(Trip_2_data);
Trip_2_data.Properties.VariableNames = {'Torquenm';
                              'Torquenm1';
                              'Torquenm2';
                              'Speedms';
                              'Speedms1';
                              'Speedms2';
                              'Powerkw1';
                              'Powerkw2';
                              'Powerkw3';
                              'Powerkw'};

% Trip 3
Trip_3_data = [Trip_3_M_Torque_final(:,2) Trip_3_M_Torque_final_k_minus_1 Trip_3_M_Torque_final_k_minus_2 Trip_3_Speed_final(:,2) Trip_3_Speed_final_k_minus_1 Trip_3_Speed_final_k_minus_2 Trip_3_kW_final_k_minus_1 Trip_3_kW_final_k_minus_2 Trip_3_kW_final_k_minus_3 Trip_3_kW_final(:,2)];
Trip_3_data = array2table(Trip_3_data);
Trip_3_data.Properties.VariableNames = {'Torquenm';
                              'Torquenm1';
                              'Torquenm2';
                              'Speedms';
                              'Speedms1';
                              'Speedms2';
                              'Powerkw1';
                              'Powerkw2';
                              'Powerkw3';
                              'Powerkw'};

% Trip 4
Trip_4_data = [Trip_4_M_Torque_final(:,2) Trip_4_M_Torque_final_k_minus_1 Trip_4_M_Torque_final_k_minus_2 Trip_4_Speed_final(:,2) Trip_4_Speed_final_k_minus_1 Trip_4_Speed_final_k_minus_2 Trip_4_kW_final_k_minus_1 Trip_4_kW_final_k_minus_2 Trip_4_kW_final_k_minus_3 Trip_4_kW_final(:,2)];
Trip_4_data = array2table(Trip_4_data);
Trip_4_data.Properties.VariableNames = {'Torquenm';
                              'Torquenm1';
                              'Torquenm2';
                              'Speedms';
                              'Speedms1';
                              'Speedms2';
                              'Powerkw1';
                              'Powerkw2';
                              'Powerkw3';
                              'Powerkw'};

% Extract weights and biases from the trained NNS model
weights1 = NNS.LayerWeights{1}'; % Layer 1 weights
biases1 = NNS.LayerBiases{1}'; % Layer 1 biases
weights2 = NNS.LayerWeights{2}'; % Layer 2 weights (output layer)
biases2 = NNS.LayerBiases{2}'; % Layer 2 biases (output layer)

% Define the ReLU activation function
relu = @(x) max(0, x);

% Get the number of rows and columns for Trip 1 data
[rt_1 ct_1] = size(Trip_1_data);

% Prepare Trip 1 input data by removing the last column (i.e. actual output, which is not required in simulation confguration)
Trip_1_data = Trip_1_data(:,1:(ct_1-1));
Trip_1_data = table2array(Trip_1_data);

% Standardize Trip 1 input data using the mean (Mu) and standard deviation (Sigma) from model parameters
Trip_1_data_std = (Trip_1_data - NNS.Mu) ./ NNS.Sigma;

for i=1:length(Trip_1_data)

% Compute the output of the first layer using the ReLU activation function
layer1Output(i,:) = relu(Trip_1_data_std(i,:) * weights1 + biases1);

% Compute the output of the second layer (final output prediction)
Trip_1_y_hat(i,:) = layer1Output(i,:) * weights2 + biases2;

% Update the input data for the next time step with the current simulated output. 
% Specifically, update the Powerkw1 (k-1), Powerkw2 (k-2), and Powerkw3 (k-3) columns
for j = 7:9
        if j==7
        % Standardize the predicted output    
        Trip_1_data_std(i+1,j) = (Trip_1_y_hat(i,:)- NNS.Mu(j))./NNS.Sigma(j);
        else
        % Shift the values of previous outputs (k-1, k-2, k-3)
        Trip_1_data_std(i+1,j) = Trip_1_data_std(i,j-1);
        end
end

end

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
[rt_2 ct_2] = size(Trip_2_data);

Trip_2_data = Trip_2_data(:,1:(ct_2-1));
Trip_2_data = table2array(Trip_2_data);

Trip_2_data_std = (Trip_2_data - NNS.Mu) ./ NNS.Sigma;

for i=1:length(Trip_2_data)

layer1Output(i,:) = relu(Trip_2_data_std(i,:) * weights1 + biases1);
Trip_2_y_hat(i,:) = layer1Output(i,:) * weights2 + biases2;

for j = 7:9
        if j==7
        Trip_2_data_std(i+1,j) = (Trip_2_y_hat(i,:)- NNS.Mu(j))./NNS.Sigma(j);
        else
        Trip_2_data_std(i+1,j) = Trip_2_data_std(i,j-1);
        end
end

end

% Actual output for comparison
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
[rt_3 ct_3] = size(Trip_3_data);

Trip_3_data = Trip_3_data(:,1:(ct_3-1));
Trip_3_data = table2array(Trip_3_data);

Trip_3_data_std = (Trip_3_data - NNS.Mu) ./ NNS.Sigma;

for i=1:length(Trip_3_data)

layer1Output(i,:) = relu(Trip_3_data_std(i,:) * weights1 + biases1);
Trip_3_y_hat(i,:) = layer1Output(i,:) * weights2 + biases2;

for j = 7:9
        if j==7
        Trip_3_data_std(i+1,j) = (Trip_3_y_hat(i,:)- NNS.Mu(j))./NNS.Sigma(j);
        else
        Trip_3_data_std(i+1,j) = Trip_3_data_std(i,j-1);
        end
end

end

% Actual output for comparison
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
[rt_4 ct_4] = size(Trip_4_data);

Trip_4_data = Trip_4_data(:,1:(ct_4-1));
Trip_4_data = table2array(Trip_4_data);

Trip_4_data_std = (Trip_4_data - NNS.Mu) ./ NNS.Sigma;

for i=1:length(Trip_4_data)

layer1Output(i,:) = relu(Trip_4_data_std(i,:) * weights1 + biases1);
Trip_4_y_hat(i,:) = layer1Output(i,:) * weights2 + biases2;

for j = 7:9
        if j==7
        Trip_4_data_std(i+1,j) = (Trip_4_y_hat(i,:)- NNS.Mu(j))./NNS.Sigma(j);
        else
        Trip_4_data_std(i+1,j) = Trip_4_data_std(i,j-1);
        end
end

end

% Actual output for comparison
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