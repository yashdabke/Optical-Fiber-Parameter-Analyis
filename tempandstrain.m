% Optical Fiber Parameters Calculator with Temperature and Strain
clc;
clear all;

% Prompt user for the number of cases to analyze
b = input("Enter how many cases you want: ");

% Loop through each case
for i = 1:b
    % Prompt user for core refractive index, cladding refractive index, core radius, temperature, and strain
    n1(i) = input("Enter the value of n1: ");
    n2(i) = input("Enter the value of n2: ");
    a(i) = input("Enter the core radius in micrometers: ");
    temperature(i) = input("Enter the temperature in degrees Celsius: ");
    strain(i) = input("Enter the strain (e.g., 0.01 for 1% strain): ");
end

% Loop through each case for calculations and display
for i = 1:b
    % Calculate critical angle at the core-cladding interface
    CA = asind(n2(i) / n1(i));
    disp("Critical angle at the core-cladding interface is:");
    disp(CA);

    % Calculate Numerical Aperture (NA)
    NA = sqrt((n1(i)^2) - (n2(i)^2));
    disp("Numerical Aperture is:");
    disp(NA);

    % Calculate cutoff wavelength
    w = (((2 * pi * a(i) * NA) / 2.404));
    disp("Cutoff wavelength is:");
    disp(w);

    % Prompt user for wavelength greater than cutoff wavelength
    lamda(i) = input("Enter the wavelength greater than cutoff wavelength: ");

    % Calculate Normalized Frequency (V)
    V = (((2 * pi * a(i) * NA) / lamda(i)));
    disp("Normalized Frequency is:");
    disp(V);
    
    % Store Normalized Frequency for later plotting
    normalize_freq(i) = V;

    % Calculate number of modes (M)
    M = ((V^2) / 2);
    disp("The number of modes:");
    disp(M);

    % Calculate acceptance angle (AA)
    AA = asind(NA);
    disp("Acceptance angle is:");
    disp(AA);

    % Calculate propagation constant (PC) considering temperature and strain
    alpha = 1e-6; % Thermal coefficient (typical value for silica)
    beta = -0.5e-6; % Strain coefficient (typical value for silica)
    
    PC = ((2 * pi * n1(i)) / lamda(i)) * cosd(AA) * (1 + alpha * temperature(i) + beta * strain(i));
    disp('Propagation constant of fiber in degrees per micrometer (considering temperature and strain):');
    disp(PC);
    
    % Calculate normalized propagation constant (NPC)
    NPC = (((1.1428 - (0.996 / V))^2));
    disp('Normalized propagation constant of fiber:');
    disp(NPC);
    
    % Store Normalized Propagation Constant for later plotting
    propagation_const(i) = NPC;

    % Determine if the fiber is single-mode or multi-mode
    if (V < 2.404)
        disp("The fiber is a single-mode fiber");
    else
        disp("The fiber is a multi-mode fiber");
    end
end

% Plotting
subplot(1, 1, 1);
plot(normalize_freq, propagation_const);
xlabel('Normalized Frequency');
ylabel('Propagation Constant');
title('Normalized Frequency vs. Propagation Constant');
