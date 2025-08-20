function overlay_MMD_sweep(rhoL_vec, rhoT_vec)
% overlay_MMD_sweep — overlay MMD envelopes for different L/t ratios
%
% Example:
%   overlay_MMD_sweep([0.8 1.0 1.2], [1.0])
%   overlay_MMD_sweep([0.9 1.0 1.1], [0.9 1.0 1.1])

% --- baseline vehicle ---
p0 = vehicle_params();
L0 = p0.lf + p0.lr;   lf0 = p0.lf; lr0 = p0.lr;
tF0 = p0.tfw;         tR0 = p0.trw;
aFrac = lf0/L0;

% --- sweep ---
figure; hold on; grid on;
xlabel('a_y [m/s^2]'); ylabel('C_N (yaw moment coeff.)');
title('MMD Envelopes, swept L and t');

for rhoL = rhoL_vec
  for rhoT = rhoT_vec
    % scale geometry
    L = L0*rhoL; lf = aFrac*L; lr = L-lf;
    tf = tF0*rhoT; tr = tR0*rhoT;
    p = p0; p.lf=lf; p.lr=lr; p.tfw=tf; p.trw=tr; p.L=L;

    % build MMD without iso-lines
    beta_vec  = linspace(-0.2,0.2,25);
    delta_vec = linspace(-0.3,0.3,25);
    [Ay, N, ~, ~, ~] = build_mmd(p, beta_vec, delta_vec, 0, 0);

    % outer envelope = convex hull
    pts = [Ay(:), N(:)];
    K = convhull(pts(:,1), pts(:,2));
    plot(pts(K,1), pts(K,2), 'DisplayName', ...
      sprintf('L/L0=%.2f, t/t0=%.2f', rhoL, rhoT));
  end
end

legend show;
end
