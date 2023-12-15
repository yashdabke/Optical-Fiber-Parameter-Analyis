clc;
clear all;
close all;

% Parameters
core_radius = 5e-6;              % Core radius of the optical fiber (in meters)
wavelength = 1550e-9;           % Operating wavelength of the optical signal (in meters)
numerical_aperture = 0.2;        % Numerical aperture of the fiber
fiber_length = 10;               % Length of the optical fiber (in meters)
amplification_length = 2;        % Length of the fiber for amplification (in meters)
speed_of_light = 3e8;            % Speed of light (in meters per second)

% Graded refractive index profile
r = linspace(0, core_radius, 100);
n_core_center = 1.5;
n_clad = 1;
n_core = n_clad + (n_core_center - n_clad) * (1 - (r / core_radius).^2);

% Calculate V-number
V_number = (2 * pi * core_radius * numerical_aperture) / wavelength;

% Display fiber parameters
disp('--- Fiber Parameters ---');
disp(['Core Refractive Index: Graded profile']);
disp(['Cladding Refractive Index: ', num2str(n_clad)]);
disp(['V-number: ', num2str(V_number)]);

% Pulse parameters
bit_rate = 10e9;                  % Bit rate of the optical signal (in bits per second)
pulse_duration = 1 / bit_rate;    % Duration of each pulse (in seconds)
num_bits = 100;                   % Number of bits in the simulation
symbol_rate = bit_rate;           % Symbol rate of the signal (in symbols per second)

% Time and frequency vectors
time = linspace(0, num_bits * pulse_duration, 1000);
frequency = linspace(-symbol_rate / 2, symbol_rate / 2, numel(time));

% Generate Gaussian pulse shape
pulse_shape = exp(-(time - pulse_duration / 2).^2 / (2 * (pulse_duration / 4e-9)^2));

% Apply narrowband filter
filter_center_frequency = 0;
filter_bandwidth = 2e9;
narrowband_filter = exp(-((frequency - filter_center_frequency) / (filter_bandwidth / 2)).^2);
filtered_pulse = pulse_shape .* narrowband_filter;

% Propagation through fiber using NLSE with amplification
beta2 = -((wavelength^2) / (2 * pi * speed_of_light)) * 0.027;
gamma = 1.27e-3;
gain_coefficient = 0.01;

% Polarization state (Jones vector)
% Linear polarization along the x-axis
Ex = real(filtered_pulse);
Ey = imag(filtered_pulse);

% NLSE solver with polarization effects
options = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[t, Ex_y] = ode45(@(t, Ex_y) nlse(t, Ex_y, beta2, gamma, gain_coefficient, amplification_length, wavelength, speed_of_light), time, [Ex; Ey]', options);

% Extract polarization components
Ex_simulated = real(Ex_y(:, 1));
Ey_simulated = imag(Ex_y(:, 2));

% Plotting
figure;

% Plot graded refractive index profile
subplot(2, 2, 1);
plot3(r, ones(size(r)), n_core, 'b-', 'LineWidth', 2);
xlabel('Radial Distance (m)');
ylabel('Axial Distance (m)');
zlabel('Refractive Index');
title('Graded Refractive Index Profile');
grid on;
view([-30, 30]);

% Plot filtered pulse shape
subplot(2, 2, 2);
plot(time, abs(filtered_pulse).^2, 'b-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Intensity');
title('Filtered Pulse Shape');
grid on;

% Plot pulse propagation through fiber with polarization
subplot(2, 2, 3);
plot(time, abs(Ex_simulated + 1i * Ey_simulated).^2, 'r--', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Intensity');
title('Pulse Propagation Through Fiber with Polarization');
grid on;

% Plot frequency domain representation
subplot(2, 2, 4);
plot(frequency, fftshift(abs(fft(filtered_pulse)).^2), 'b-', 'LineWidth', 2);
hold on;
plot(frequency, fftshift(abs(fft(Ex_simulated + 1i * Ey_simulated)).^2), 'r--', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density');
title('Frequency Domain');
legend('Filtered (Original)', 'Simulated (After Fiber)');
grid on;

% Spectral Phase and Intensity before propagation
figure;

% Plot spectral phase before propagation
subplot(2, 2, 1);
plot(frequency, angle(fftshift(fft(filtered_pulse))), 'b-', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Spectral Phase');
title('Spectral Phase (Before Fiber)');
grid on;

% Plot spectral intensity before propagation
subplot(2, 2, 2);
plot(frequency, fftshift(abs(fft(filtered_pulse)).^2), 'b-', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Spectral Intensity');
title('Spectral Intensity (Before Fiber)');
grid on;

% Spectral Phase and Intensity after propagation
subplot(2, 2, 3);
plot(frequency, angle(fftshift(fft(Ex_simulated + 1i * Ey_simulated))), 'r--', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Spectral Phase');
title('Spectral Phase (After Fiber)');
grid on;

% Plot spectral intensity after propagation
subplot(2, 2, 4);
plot(frequency, fftshift(abs(fft(Ex_simulated + 1i * Ey_simulated)).^2), 'r--', 'LineWidth', 2);
xlabel('Frequency (Hz)');
ylabel('Spectral Intensity');
title('Spectral Intensity (After Fiber)');
grid on;

% Temporal evolution of the pulse during propagation
figure;
plot(time, abs(Ex_simulated + 1i * Ey_simulated).^2, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Intensity');
title('Temporal Evolution of the Pulse during Propagation');
grid on;

% Display additional results
disp('--- Pulse Parameters ---');
disp(['Bit Rate: ', num2str(bit_rate / 1e9), ' Gbps']);
disp(['Pulse Duration: ', num2str(pulse_duration * 1e9), ' ns']);
disp(['Symbol Rate: ', num2str(symbol_rate / 1e9), ' Gbaud']);

disp('--- Amplification Parameters ---');
disp(['Amplification Length: ', num2str(amplification_length), ' m']);
disp(['Gain Coefficient: ', num2str(gain_coefficient)]);

disp('--- Filter Parameters ---');
disp(['Filter Center Frequency: ', num2str(filter_center_frequency), ' Hz']);
disp(['Filter Bandwidth: ', num2str(filter_bandwidth / 1e9), ' GHz']);

disp('--- Validation ---');
% Calculate theoretical pulse broadening
theoretical_pulse_duration = pulse_duration * sqrt(1 + (beta2 * fiber_length * symbol_rate)^2);

% Display theoretical pulse broadening
disp(['Theoretical Pulse Broadening: ', num2str(theoretical_pulse_duration * 1e9), ' ns']);

% Display simulated pulse broadening
disp(['Simulated Pulse Broadening: ', num2str((max(time) - min(time)) * 1e9), ' ns']);

% NLSE function definition
function dEx_ydt = nlse(t, Ex_y, beta2, gamma, gain_coefficient, amplification_length, lambda, c)
    % Extract polarization components
    Ex = Ex_y(1:end/2);
    Ey = Ex_y(end/2+1:end);

    % Nonlinear Schrödinger Equation (NLSE) for pulse propagation with polarization
    dExdt = -1i * beta2 / 2 * (c / lambda)^2 * Ex + 1i * gamma * (abs(Ex).^2 + abs(Ey).^2) .* Ex;
    dEydt = -1i * beta2 / 2 * (c / lambda)^2 * Ey + 1i * gamma * (abs(Ex).^2 + abs(Ey).^2) .* Ey;

    % Amplification term (gain)
    if t <= amplification_length
        dExdt = dExdt + gain_coefficient * Ex;
        dEydt = dEydt + gain_coefficient * Ey;
    end

    dEx_ydt = [dExdt; dEydt];
end
