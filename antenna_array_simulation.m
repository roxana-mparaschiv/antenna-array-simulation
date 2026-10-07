%% ANTENNA ARRAY & RADIATION PATTERN SIMULATION
% Course: Antennas and Propagation (ETTI UPB)
% Author: Maria-Roxana Paraschiv
% Description: Analytical modeling of a 3-element half-wavelength dipole array
%              at 140 MHz, impedance analysis, HPBW, 3D pattern, and ground plane effects.

clear; close all; clc;

%% 1. GLOBAL PROJECT PARAMETERS
no_of_project = 7;
f0 = 20e6 * no_of_project;         % Resonant frequency: 140 MHz
c = 3e8;                           % Speed of light (m/s)
lambda = c / f0;                   % Wavelength (m) ~ 2.14 m
k = 2 * pi / lambda;               % Wavenumber (rad/m)
L = lambda / 2;                    % Dipole length (m)
d = 0.65 * lambda;                 % Inter-element spacing (m)
eta0 = 120 * pi;                   % Free-space intrinsic impedance (~377 Ohm)

% Element excitations (Amplitudes and progressive phases)
I01 = no_of_project;               % 7 A
I02 = no_of_project + 1;           % 8 A
I03 = no_of_project + 2;           % 9 A

beta01_rad = 45 * pi / 180;
beta02_rad = (45 + no_of_project) * pi / 180;       % 52 deg
beta03_rad = (90 + no_of_project) * pi / 180;       % 97 deg

% Positions along z-axis (symmetric around origin)
z1 = -d; z2 = 0; z3 = d;

%% 2. CURRENT & VOLTAGE DISTRIBUTIONS (L = lambda/2 vs L = lambda)
z_dipole = linspace(-L/2, L/2, 1000);
I_z = sin(k * (L/2 - abs(z_dipole)));
I_z_norm = I_z / max(abs(I_z));
V_z = cos(k * (L/2 - abs(z_dipole)));
V_z_norm = V_z / max(abs(V_z));

L_double = lambda;
z_dipole_double = linspace(-L_double/2, L_double/2, 1000);
I_z_double = sin(k * (L_double/2 - abs(z_dipole_double)));
I_z_double_norm = I_z_double / max(abs(I_z_double));
V_z_double = cos(k * (L_double/2 - abs(z_dipole_double)));
V_z_double_norm = V_z_double / max(abs(V_z_double));

figure('Name', 'Current and Voltage Distribution', 'Position', [100, 100, 800, 600]);
subplot(2,1,1);
plot(z_dipole, I_z_norm, 'b-', 'LineWidth', 2); hold on;
plot(z_dipole_double, I_z_double_norm, 'r--', 'LineWidth', 2); grid on;
xlabel('z (m)'); ylabel('Normalized current');
title('Current distribution: \lambda/2 vs \lambda');
legend('I(z) (L=\lambda/2)', 'I(z) scaled (L=\lambda)', 'Location', 'northeast');

subplot(2,1,2);
plot(z_dipole, V_z_norm, 'b-', 'LineWidth', 2); hold on;
plot(z_dipole_double, V_z_double_norm, 'r--', 'LineWidth', 2); grid on;
xlabel('z (m)'); ylabel('Normalized voltage');
title('Voltage distribution');
legend('V(z) (L=\lambda/2)', 'V(z) scaled (L=\lambda)', 'Location', 'northeast');

%% 3. INPUT IMPEDANCE VS FREQUENCY FOR DIFFERENT RADII
f_band = linspace(0.8*f0, 1.2*f0, 500);
f_MHz = f_band / 1e6;
radii = [lambda/1000, lambda/500, lambda/200, lambda/100];
colors = {'b', 'r', 'g', 'm'};
labels = {'a = \lambda/1000', 'a = \lambda/500', 'a = \lambda/200', 'a = \lambda/100'};

figure('Name', 'Input Impedance Analysis', 'Position', [150, 150, 900, 600]);
for idx = 1:length(radii)
    a = radii(idx);
    R_in = zeros(size(f_band));
    X_in = zeros(size(f_band));
    for i = 1:length(f_band)
        lam_i = c / f_band(i);
        k_i = 2 * pi / lam_i;
        kL = k_i * L;
        R_in(i) = 73 * (sin(kL/2))^2;
        factor = (cos(kL) - cos(kL/2)) / sin(kL/2);
        X_in(i) = (eta0 / (4*pi)) * (log(L/a) - 1) * factor;
    end
    subplot(2,1,1);
    plot(f_MHz, R_in, colors{idx}, 'LineWidth', 1.8); hold on;
    subplot(2,1,2);
    plot(f_MHz, X_in, colors{idx}, 'LineWidth', 1.8); hold on;
end

subplot(2,1,1); grid on; title('Input Resistance R vs Frequency');
xlabel('Frequency [MHz]'); ylabel('Resistance R [\Omega]');
legend(labels, 'Location', 'best');

subplot(2,1,2); grid on; title('Input Reactance X vs Frequency');
xlabel('Frequency [MHz]'); ylabel('Reactance X [\Omega]');
plot([min(f_MHz) max(f_MHz)], [0 0], 'k--', 'LineWidth', 1.2);
legend([labels, {'X = 0'}], 'Location', 'best');

%% 4. ARRAY FACTOR, DIRECTIVITY & 3D RADIATION PATTERN
theta = linspace(0, pi, 361);
phi = linspace(0, 2*pi, 361);
[THETA, PHI] = meshgrid(theta, phi);

% Single dipole element pattern
F_dipole = cos((pi/2) * cos(THETA)) ./ sin(THETA);
F_dipole(isnan(F_dipole) | isinf(F_dipole)) = 0;

% Array factor computation in 3D
psi1 = k * z1 * cos(THETA);
psi2 = k * z2 * cos(THETA);
psi3 = k * z3 * cos(THETA);
AF = I01 * exp(1j*(psi1 + beta01_rad)) + ...
     I02 * exp(1j*(psi2 + beta02_rad)) + ...
     I03 * exp(1j*(psi3 + beta03_rad));
AF_mag = abs(AF);

% Total field and radiation intensity
E_total = abs(F_dipole) .* AF_mag;
E_norm = E_total / max(E_total(:));
U = E_total.^2;

% Numerical integration for total radiated power
dtheta = theta(2) - theta(1);
dphi = phi(2) - phi(1);
P_rad = 0;
for j = 1:length(theta)
    P_rad = P_rad + sum(U(:, j)) * sin(theta(j)) * dtheta * dphi;
end

% Directivity & Gain
D = (4 * pi * U) / P_rad;
D_max = max(D(:));
D_max_dBi = 10 * log10(D_max);

eta_rad = 0.95;                    % 95% radiation efficiency
G = eta_rad * D;
G_max = max(G(:));
G_max_dBi = 10 * log10(G_max);

fprintf('--- ANTENNA ARRAY PERFORMANCE ---\n');
fprintf('Maximum Directivity: %.2f dBi\n', D_max_dBi);
fprintf('Maximum Gain (eta=0.95): %.2f dBi\n', G_max_dBi);

% 3D Radiation Pattern Plot
figure('Name', '3D Radiation Pattern', 'Position', [200, 200, 800, 600]);
X_3D = E_norm .* sin(THETA) .* cos(PHI);
Y_3D = E_norm .* sin(THETA) .* sin(PHI);
Z_3D = E_norm .* cos(THETA);
surf(X_3D, Y_3D, Z_3D, E_norm, 'EdgeColor', 'none');
colormap jet; colorbar; axis equal;
title('3D Normalized Radiation Pattern');
xlabel('x'); ylabel('y'); zlabel('z');
view(45, 30);

%% 5. HALF-POWER BEAMWIDTH (HPBW) COMPARISON
theta_deg = theta * 180 / pi;
F_dip_1D = cos((pi/2) * cos(theta)) ./ sin(theta);
F_dip_1D(isnan(F_dip_1D) | isinf(F_dip_1D)) = 0;
P_dip_norm = (abs(F_dip_1D) / max(abs(F_dip_1D))).^2;

psi1_1D = k * z1 * cos(theta);
psi2_1D = k * z2 * cos(theta);
psi3_1D = k * z3 * cos(theta);
AF_1D = I01 * exp(1j*(psi1_1D + beta01_rad)) + ...
        I02 * exp(1j*(psi2_1D + beta02_rad)) + ...
        I03 * exp(1j*(psi3_1D + beta03_rad));
E_arr_1D = abs(F_dip_1D) .* abs(AF_1D);
P_arr_norm = (E_arr_1D / max(E_arr_1D)).^2;

% Calculate HPBW (-3 dB / 0.5 level)
idx_dip = find(P_dip_norm >= 0.5);
HPBW_dip = theta_deg(idx_dip(end)) - theta_deg(idx_dip(1));

idx_arr = find(P_arr_norm >= 0.5);
HPBW_arr = theta_deg(idx_arr(end)) - theta_deg(idx_arr(1));

fprintf('HPBW Single Dipole: %.2f deg\n', HPBW_dip);
fprintf('HPBW 3-Dipole Array: %.2f deg\n', HPBW_arr);

figure('Name', 'HPBW Comparison', 'Position', [250, 250, 800, 500]);
plot(theta_deg, P_dip_norm, 'b-', 'LineWidth', 2); hold on;
plot(theta_deg, P_arr_norm, 'r-', 'LineWidth', 2);
plot([0 180], [0.5 0.5], 'k--', 'LineWidth', 1.2); grid on;
xlabel('Angle \theta [degrees]'); ylabel('Normalized Power');
title(sprintf('HPBW Comparison: Dipole (%.1f°) vs Array (%.1f°)', HPBW_dip, HPBW_arr));
legend('Single Dipole', '3-Dipole Array', '-3 dB threshold', 'Location', 'northeast');

%% 6. PERFECT GROUND PLANE SIMULATION (IMAGE THEORY)
h = lambda / 4;                    % Height above ground
phase_diff = 2 * k * h * cos(theta);
F_ground = zeros(size(theta));
for i = 1:length(theta)
    if theta(i) <= pi/2
        F_ground(i) = abs(F_dip_1D(i) * (1 - exp(1j * phase_diff(i))));
    else
        F_ground(i) = 0;           % Shielded by ground plane
    end
end
F_ground_norm = F_ground / max(F_ground);

figure('Name', 'Ground Plane Effect', 'Position', [300, 300, 700, 500]);
polarplot(theta, F_dip_1D / max(F_dip_1D), 'b-', 'LineWidth', 2); hold on;
polarplot(theta, F_ground_norm, 'r-', 'LineWidth', 2.2);
title('Radiation Pattern: Free Space vs. Perfect Ground Plane (h = \lambda/4)');
legend('Free Space', 'With Ground Plane (PEC)', 'Location', 'southoutside');

%% 7. FRIIS TRANSMISSION EQUATION CALCULATION
Pt = 1;                            % Transmit power (1 W)
R_dist = 20;                       % Separation distance (20 m)
Gt_lin = 1.64;                     % Half-wave dipole gain (linear)
Gr_lin = 1.64;
Pr = Pt * Gt_lin * Gr_lin * (lambda / (4 * pi * R_dist))^2;
Pr_uW = Pr * 1e6;
Pr_dBm = 10 * log10(Pr * 1e3);

fprintf('\n--- FRIIS TRANSMISSION LINK BUDGET ---\n');
fprintf('Transmit Power: %.2f W\n', Pt);
fprintf('Distance: %.2f m\n', R_dist);
fprintf('Received Power: %.3f uW (%.2f dBm)\n', Pr_uW, Pr_dBm);