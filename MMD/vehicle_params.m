function p = vehicle_params()
% Vehicle geometry (edit to your car)
p.m  = 236.988 + 68;          % kg
p.lf = 3.073 * 0.535;         % m
p.lr = 3.073 - p.lf;         % m   (L = lf+lr = 1.50 m)
p.tfw = 1.220;        % m   front track
p.trw = 1.234;        % m   rear track
p.hCG = 0.273;        % m   CG height
p.Iz  = 500;         % kg·m^2 (not used in steady-state MMD calc)

% Roll stiffness distribution (for lateral load transfer split)
p.kphi_f = 22918.3;     % N·m/rad
p.kphi_r = 20053.5;     % N·m/rad

% Static verticals
p.g  = 9.81;
p.Wf = p.m * p.g * (p.lr/(p.lf+p.lr));
p.Wr = p.m * p.g * (p.lf/(p.lf+p.lr));

% Tire "semi-empirical" lateral & longitudinal stiffness scaling vs load
p.Fz_ref = 1000;     % N (reference load per tire for stiffness scaling)
p.Ca_ref = 80000;    % N/rad (per tire at Fz_ref)  (adjust for your tires)
p.Ck_ref = 80000;    % N     (longitudinal “stiffness” scale for Fx model)
p.load_exp = 0.9;    % load sensitivity exponent for stiffness

% --- Pacejka Magic Formula (example values; tune to your tire data) ---
% Lateral (alpha)
p.pacejka_lat.B = 23.5;     % stiffness factor
p.pacejka_lat.C = 1.4;      % shape factor
p.pacejka_lat.D = 1.45;     % peak factor (multiplies Fz inside MF)
p.pacejka_lat.E = 0.9;     % curvature factor

% Longitudinal (kappa)
p.pacejka_long.B = 15.0;
p.pacejka_long.C = 1.8;
p.pacejka_long.D = 1.40;
p.pacejka_long.E = 0.95;

% Global friction cap (used by ellipse scaling)
p.mu = 1.4;


% Friction
p.mu = 1.2;          % peak friction cap (scale both Fy and Fx saturation)

% Numerics
p.maxIter = 60;
p.tol     = 1e-6;

% Speed placeholder (set in main)
p.Ux = 11;           % m/s (overwritten in main)

end
