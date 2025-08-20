%% Assumptions and Notes
% Gift from DUO
% This helps understand the effects of track width and wheelbase by plotting the Milliken Moment Diagram (Yaw-Moment)
% This uses the methods found in "Vehicle agile maneuvering: From rally drivers to a finite state machine approach" by Acosta, M, Kanarachos, S & Blundell, M

clc; close all;

%% Parameters
p = vehicle_params();     % your vehicle struct
p.Ux = 20;                % [m/s] constant speed for the MMD
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
[Ay, N, CN, beta_grid, delta_grid] = build_mmd(p, beta_vec, delta_vec, kappa_f, kappa_r);

% axes variables
Ay_g = Ay / p.g;          % lateral acceleration in g (x-axis)
CN_map = CN;              % normalized yaw moment (y-axis)

%% PLOT: base steering isolines + labeled iso-β and iso-δ
figure('Color','w'); hold on; grid on; box on;

% --- Base: steering isolines (each column is a fixed δ, varying β) ---
cmap = lines(numel(delta_vec));      % or any colormap you prefer
for j = 1:numel(delta_vec)
    plot(Ay_g(:,j), CN_map(:,j), 'Color',[0.5 0.5 0.5], 'LineWidth', 1.0); % light gray lines
end

% --- Prepare fields for contour labeling ---
beta_deg  = beta_grid  * 180/pi;     % Z field for iso-β contours (deg)
delta_deg = delta_grid * 180/pi;     % Z field for iso-δ contours (deg)

% Choose which β and δ levels to label (deg)
beta_levels_deg  = (-12:3:18);       % adjust density for readability
delta_levels_deg = (-40:5:40);

% --- Iso-β contours (solid black) with labels ---
[Cb,hb] = contour(Ay_g, CN_map, beta_deg, beta_levels_deg, ...
                  'LineColor', [0 0 0], 'LineStyle','-', 'LineWidth', 0.9);
htb = clabel(Cb, hb, 'LabelSpacing', 300, 'FontSize', 8, 'Color', [0 0 0]);
% Prefix labels with β=
for k = 1:numel(htb)
    set(htb(k), 'String', ['\beta=', htb(k).String, '^{\circ}'], ...
        'BackgroundColor','w', 'Margin', 2, 'Interpreter','tex');
end

% --- Iso-δ contours (dashed red) with labels ---
[Cd,hd] = contour(Ay_g, CN_map, delta_deg, delta_levels_deg, ...
                  'LineColor', [0.85 0 0], 'LineStyle','--', 'LineWidth', 0.9);
htd = clabel(Cd, hd, 'LabelSpacing', 300, 'FontSize', 8, 'Color', [0.85 0 0]);
for k = 1:numel(htd)
    set(htd(k), 'String', ['\delta=', htd(k).String, '^{\circ}'], ...
        'BackgroundColor','w', 'Margin', 2, 'Interpreter','tex');
end

% Axis labels & title
xlabel('Lateral acceleration a_y  [g]');
ylabel('Normalized yaw moment C_N = N / (m g (l_f + l_r))');
title(sprintf('Moment Method Diagram (U_x = %.1f m/s)', p.Ux));

% Legend (proxies)
plot(nan,nan,'-','Color',[0 0 0],'LineWidth',0.9); 
plot(nan,nan,'--','Color',[0.85 0 0],'LineWidth',0.9);
legend({'steering isolines','iso-\beta','iso-\delta'}, 'Location','best');

% Optional: tidy limits
xlim([min(Ay_g(:)) max(Ay_g(:))]); 
ylim([min(CN_map(:)) max(CN_map(:))]);

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