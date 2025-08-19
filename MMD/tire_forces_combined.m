function [Fy, Fx] = tire_forces_combined(p, Fz, alpha, kappa)
% Stiffness vs load
Ca = p.Ca_ref * (Fz/p.Fz_ref)^p.load_exp;
Ck = p.Ck_ref * (Fz/p.Fz_ref)^p.load_exp;

% Pure components
Fy0 = p.mu * Fz * tanh( (Ca/(p.mu*Fz)) * alpha );
Fx  = p.mu * Fz * tanh( (Ck/(p.mu*Fz)) * kappa );

% Friction ellipse weighting (keep sign of Fy0)
util = min(1.0, abs(Fx)/(p.mu*Fz));
Gy   = sqrt(max(0, 1 - util^2));
Fy   = Gy * Fy0;
end
