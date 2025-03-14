% Plot Properties
set(0, 'defaultaxesfontsize', 20)
set(0, 'DefaultFigureWindowStyle', 'docked')
set(0, 'DefaultLineLineWidth', 2)
set(0, 'Defaultaxeslinewidth', 2)
set(0, 'DefaultFigureWindowStyle', 'docked')

% Given parameters
Is = 0.01e-12;  % Is in Amperes (0.01 pA)
Ib = 0.1e-12;   % Ib in Amperes (0.1 pA)
Vb = 1.3;       % Vb in Volts
Gp = 0.1;       % Gp in Ohm^-1

% Create a V vector from -1.95 to 0.7 volts with 200 steps
V = linspace(-1.95, 0.7, 200);

% Calculate the ideal diode current (Shockley model)
I_ideal = Is * (exp((1.2 / 0.025)*V) - 1);

% Calculate the current due to the parallel resistor
I_parallel = Gp * V;

% Calculate the current due to the breakdown region
I_breakdown = Ib * (exp(-1.2 * (V + Vb) / 0.025) - 1);

% Total current (sum of all components)
I_total = I_ideal + I_parallel - I_breakdown;

% Add noise (20% random variation)
noise = 0.2 * randn(size(V));
I_noisy = I_total + noise;

% Fit a 4th-order polynomial to the noisy data
p4 = polyfit(V, I_total , 4);  % Polynomial of degree 4
I_fit4 = polyval(p4, V);      % Evaluate the polynomial at V

% Fit an 8th-order polynomial to the noisy data
p8 = polyfit(V, I_total , 8);  % Polynomial of degree 8
I_fit8 = polyval(p8, V);      % Evaluate the polynomial at V


% Plotting the data (Linear Scale)
figure;
%plot(V, I_ideal, 'b', 'DisplayName', 'Ideal Diode Current (I_{ideal})'); hold on;
plot(V, I_total, 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
%plot(V, I_noisy, 'r--', 'DisplayName', 'Noisy Data (I_{noisy})'); hold on;
% Plot the polynomial fits
plot(V, I_fit4, 'b-', 'DisplayName', '4th Order Polynomial Fit'); hold on;
plot(V, I_fit8, 'm-', 'DisplayName', '8th Order Polynomial Fit'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage for Diode Model');
legend;
grid on;
hold off;

% Plot the semilogy (Logarithmic scale for current)
figure;
%semilogy(V, abs(I_ideal), 'b', 'DisplayName', 'Ideal Diode Current (I_{ideal})'); hold on;
semilogy(V, abs(I_total), 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
%semilogy(V, abs(I_noisy), 'r--', 'DisplayName', 'Noisy Data (I_{noisy})'); hold on;
% Plot the polynomial fits
semilogy(V, abs(I_fit4), 'b-', 'DisplayName', '4th Order Polynomial Fit'); hold on;
semilogy(V, abs(I_fit8), 'm-', 'DisplayName', '8th Order Polynomial Fit'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage (Log Scale) for Diode Model');
legend;
grid on;
hold off;



% Define the nonlinear model for fitting
fo2 = fittype('A*(exp(1.2*x/25e-3)-1) + 0.1036*x - C*(exp(1.2*(-(x+1.8150))/25e-3)-1)');
ff2 = fit(V(:), I_total(:), fo2);
If2 = ff2(V);

% Define the nonlinear model for fitting
fo3 = fittype('A*(exp(1.2*x/25e-3)-1) + B*x - C*(exp(1.2*(-(x+1.8150))/25e-3)-1)');
ff3 = fit(V(:), I_total(:), fo3);
If3 = ff3(V);

% Define the nonlinear model for fitting
fo4 = fittype('A*(exp(1.2*x/25e-3)-1) + B*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff4 = fit(V(:), I_total(:), fo4);
If4 = ff4(V);

% Extract the fitted parameters
% params = coeffvalues(ff);

% Display the parameters
% A = params(1);
% B = params(2);
% C = params(3);
% D = params(4);
% Best possible fit:
% A = 9.695e-15
% B = 0.1036
% C = 0.0053
% D = 1.8150

figure;
%Plot the 
plot(V, I_total, 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
plot(V, If2, 'r-', 'DisplayName', 'Nonlinear Fit 2 (I_{total})'); hold on;
plot(V, If3, 'b-', 'DisplayName', 'Nonlinear Fit 3(I_{total})'); hold on;
plot(V, If4, 'c-', 'DisplayName', 'Nonlinear Fit 4 (I_{total})'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage for Diode Model');
legend;
grid on;
hold off;

% Plot the semilogy (Logarithmic scale for current)
figure;
semilogy(V, abs(I_total), 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
% Plot the polynomial fits
semilogy(V, abs(If2), 'b-', 'DisplayName', 'Nonlinear Fit 2 (I_{total})'); hold on;
semilogy(V, abs(If3), 'm-', 'DisplayName', 'Nonlinear Fit 3 (I_{total})'); hold on;
semilogy(V, abs(If4), 'm-', 'DisplayName', 'Nonlinear Fit 4 (I_{total})'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage (Log Scale) for Diode Model');
legend;
grid on;
hold off;


inputs = V.';
targets = I_noisy.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
%view(net)
Inn = outputs;

% Plot the results
figure;

% Plot the original total current and the fitted curve by the neural network
plot(V, I_noisy, 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
plot(V, Inn, 'r--', 'DisplayName', 'Neural Network Fit (I_{total})'); hold on;

xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage for Diode Model with Neural Network Fit');
legend;
grid on;
hold off;

% Plot the results
figure;

% Plot the original total current and the fitted curve by the neural network
semilogy(V, abs(I_noisy), 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
semilogy(V, abs(Inn), 'r--', 'DisplayName', 'Neural Network Fit (I_{total})'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage for Diode Model (Log Scale) with Neural Network Fit');
legend;
grid on;
hold off;

% Define the input (V) and target (I_total) data
inputs = V.';  % Transpose the voltage data (to match expected input format for GPR)
targets = I_total.';  % Transpose the current data

% Fit the Gaussian Process Regression model
m = fitrgp(inputs, targets);

% Define the new voltage values for prediction (xp)
xp = linspace(-2, 0.7, 300).';  % Transpose to match the expected input format

% Make predictions for the new voltage values
[ypred_new, ysd_new, yci_new] = predict(m, xp);

% Plot the original data and the GPR predictions
figure;
plot(V, I_total, 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
plot(xp, ypred_new, 'b-', 'DisplayName', 'Predictions for New V (I_{total})'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage for Diode Model using GPR (New Predictions)');
legend;
grid on;
hold off;

% Plot the original data and the GPR predictions
figure;
semilogy(V, abs(I_total), 'g', 'DisplayName', 'Total Current (I_{total})'); hold on;
semilogy(xp, abs(ypred_new), 'b-', 'DisplayName', 'Predictions for New V (I_{total})'); hold on;
xlabel('Voltage (V)');
ylabel('Current (I) [A]');
title('Current vs Voltage for Diode Model (log scale) using GPR (New Predictions)');
legend;
grid on;
hold off;
