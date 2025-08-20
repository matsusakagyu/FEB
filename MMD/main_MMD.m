%% Assumptions and Notes
% Gift from DUO
% This helps understand the effects of track width and wheelbase by plotting the Milliken Moment Diagram (Yaw-Moment)
% This uses the methods found in "Vehicle agile maneuvering: From rally drivers to a finite state machine approach" by Acosta, M, Kanarachos, S & Blundell, M

clc; close all;

%% Parameters
p = vehicle_params();     % your vehicle struct
p.Ux = 11;                % [m/s] constant speed for the MMD
p.g  = 9.80665;           % gravity (for ay in g)

% sweeps (wide enough to reach envelope; tune to your car)
beta_vec  = deg2rad(linspace(-12, 18, 61));   % [rad]
delta_vec = deg2rad(linspace(-40, 40, 81));   % [rad]

% (optional) longitudinal slips for combined-slip model
kappa_f = 0.0;            % front
kappa_r = 0.0;            % rear

%% Build MMD surface
% Ay [nb x nd] in m/s^2, N [nb x nd] in N*m, CN normalized,
% and the β/δ grids (same size as Ay/CN).
[Ay, N, CN, beta_grid, delta_grid, Ay_g] = build_mmd(p, beta_vec, delta_vec, kappa_f, kappa_r);

%% -------- Plotting Section --------
figure; hold on; grid on;

% === Filled background ===
% This is the yaw moment coefficient map (CN)
contourf(Ay_g, CN, CN, 20, 'LineStyle','none'); 
colormap(turbo); 
colorbar;
xlabel('a_y [m/s^2]'); 
ylabel('C_N (yaw moment coeff.)');
title('Moment Method Diagram (MMD)');

% === Iso-beta lines ===
% Style controls (change here to update appearance)
beta_line_color = 'k';       % black
beta_line_style = '-';       % solid
beta_line_width = 1.2;       % thicker than default
beta_levels = -20:1:20;      % label values [deg]

[C_beta,h_beta] = contour(Ay_g, CN, beta_grid*180/pi, beta_levels, ...
    'LineColor', beta_line_color, ...
    'LineStyle', beta_line_style, ...
    'LineWidth', beta_line_width);
clabel(C_beta, h_beta, 'Color', beta_line_color, ...
    'FontSize', 8, 'LabelSpacing', 400);

% === Iso-delta lines ===
% Style controls
delta_line_color = 'r';      % red
delta_line_style = '--';     % dashed
delta_line_width = 1.2;
delta_levels = -20:1:20;     % label values [deg]

[C_delta,h_delta] = contour(Ay_g, CN, delta_grid*180/pi, delta_levels, ...
    'LineColor', delta_line_color, ...
    'LineStyle', delta_line_style, ...
    'LineWidth', delta_line_width);
clabel(C_delta, h_delta, 'Color', delta_line_color, ...
    'FontSize', 8, 'LabelSpacing', 400);

% === Legend ===
legend([h_beta(1), h_delta(1)], ...
       {'\beta [deg]','\delta [deg]'}, ...
       'Location','best');

%xlim([-1.1, 1.1]); ylim([-1.1, 1.1]);


% Optional: tidy limits
%xlim([min(Ay_g(:)) max(Ay_g(:))]); 
%ylim([min(CN_map(:)) max(CN_map(:))]);

%{
% --- Beta Method (project N across delta at each beta) ---
[Nmax_beta, Nmin_beta] = build_beta(N, beta_grid, delta_grid);
figure('Name','Beta Method'); hold on; grid on;
plot(rad2deg(beta_vec), Nmax_beta, 'LineWidth', 1.8);
plot(rad2deg(beta_vec), Nmin_beta, 'LineWidth', 1.8);
xlabel('\beta [deg]'); ylabel('Yaw moment N [N·m]');
title('Beta Method (Envelope of N vs \beta across \delta)');
legend('N_{max}(\beta)','N_{min}(\beta)','Location','Best');

% --- (Optional) Show same Beta plot in normalized yaw moment if desired ---
CNmax_beta = Nmax_beta ./ (p.m * p.g * (p.lf + p.lr));
CNmin_beta = Nmin_beta ./ (p.m * p.g * (p.lf + p.lr));
figure('Name','Beta Method (normalized)'); hold on; grid on;
plot(rad2deg(beta_vec), CNmax_beta, 'LineWidth', 1.8);
plot(rad2deg(beta_vec), CNmin_beta, 'LineWidth', 1.8);
xlabel('\beta [deg]'); ylabel('C_N [-]');
title('Beta Method (Envelope of C_N vs \beta)');
legend('C_{N,max}(\beta)','C_{N,min}(\beta)','Location','Best');
%}