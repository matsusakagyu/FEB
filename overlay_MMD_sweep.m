function overlay_MMD_ratio(L_over_t_vec, L_ref)
% overlay_MMD_ratio — overlay MMD envelopes for different L/t ratios
%
% Inputs:
%   L_over_t_vec - vector of wheelbase/track ratios to sweep (e.g. 1.2:0.2:2.0)
%   L_ref        - reference wheelbase to hold constant (m)
%
% Example:
%   overlay_MMD_ratio([1.4 1.6 1.8], 1.5)

% --- baseline vehicle ---
p0 = vehicle_params();
g = 9.81;

% --- sweep ---
figure; hold on; grid on;
xlabel('a_y / g [-]'); ylabel('C_N = N / (m g L) [-]');
title('Normalized MMD Envelopes, swept L/t ratio');

for rho = L_over_t_vec
    % Fix L at reference, compute t from ratio
    L  = L_ref;
    tF = L / rho;  % front track
    tR = L / rho;  % rear track (assume symmetric)
    lf = p0.lf / (p0.lf+p0.lr) * L;  % keep same CG position fraction
    lr = L - lf;

    % Update vehicle struct
    p = p0; 
    p.L=L; p.lf=lf; p.lr=lr;
    p.tfw=tF; p.trw=tR;

    % Build MMD
    beta_vec  = linspace(-0.2,0.2,25);
    delta_vec = linspace(-0.3,0.3,25);
    [Ay, N, ~, ~, ~] = build_mmd(p, beta_vec, delta_vec, 0, 0);

    % Normalize
    Ay_norm = Ay / g;
    CN      = N ./ (p.m * g * L);

    % Outer envelope (convex hull)
    pts = [Ay_norm(:), CN(:)];
    K = convhull(pts(:,1), pts(:,2));
    plot(pts(K,1), pts(K,2), 'DisplayName', sprintf('L/t = %.2f', rho));
end

legend show;
end
