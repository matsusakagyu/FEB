function [Ay, N, CN, beta_grid, delta_grid] = build_mmd(p, beta_vec, delta_vec, kappa_f, kappa_r)
nb = numel(beta_vec); nd = numel(delta_vec);
Ay = nan(nb, nd);
N  = nan(nb, nd);
CN = nan(nb, nd);

[beta_grid, delta_grid] = ndgrid(beta_vec, delta_vec);

for ib = 1:nb
    beta = beta_vec(ib);
    for jd = 1:nd
        delta = delta_vec(jd);
        % solve this operating point
        [Ay_ij, N_ij] = solve_point_2(p, beta, delta, kappa_f, kappa_r);
        Ay(ib,jd) = Ay_ij;
        N(ib,jd)  = N_ij;
        CN(ib,jd) = N_ij / (p.m * p.g * (p.lf + p.lr));  % Eq. (1) in the paper
    end
end
end
