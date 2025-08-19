function p = vehicle_params()
% Vehicle geometry (edit to your car)
p.m  = 280;          % kg
p.lf = 0.80;         % m
p.lr = 0.70;         % m   (L = lf+lr = 1.50 m)
p.tfw = 1.20;        % m   front track
p.trw = 1.20;        % m   rear track
p.hCG = 0.25;        % m   CG height
p.Iz  = 120;         % kg·m^2 (not used in steady-state MMD calc)

% Roll stiffness distribution (for lateral load transfer split)
p.kphi_f = 3000;     % N·m/rad
p.kphi_r = 2700;     % N·m/rad

% Static verticals
p.g  = 9.81;
p.Wf = p.m * p.g * (p.lr/(p.lf+p.lr));
p.Wr = p.m * p.g * (p.lf/(p.lf+p.lr));

% Tire "semi-empirical" lateral & longitudinal stiffness scaling vs load
p.Fz_ref = 1000;     % N (reference load per tire for stiffness scaling)
p.Ca_ref = 80000;    % N/rad (per tire at Fz_ref)  (adjust for your tires)
p.Ck_ref = 80000;    % N     (longitudinal “stiffness” scale for Fx model)
p.load_exp = 0.9;    % load sensitivity exponent for stiffness

% Friction
p.mu = 1.6;          % peak friction cap (scale both Fy and Fx saturation)

% Numerics
p.maxIter = 60;
p.tol     = 1e-6;

% Speed placeholder (set in main)
p.Ux = 20;           % m/s (overwritten in main)
end
