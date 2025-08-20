function Fy = pacejka_tire(alpha, Fz, pacejka)
% pacejka_tire - computes lateral tire force using Magic Formula
%
% Inputs:
%   alpha   - slip angle [rad]
%   Fz      - vertical load on tire [N]
%   pacejka - struct with coefficients {B,C,D,E}
%
% Output:
%   Fy      - lateral force [N]

% Unpack parameters
B = pacejka.B; 
C = pacejka.C; 
D = pacejka.D * Fz;    % scale with load
E = pacejka.E;

% Magic Formula
Fy = D .* sin( C .* atan( B.*alpha - E.*(B.*alpha - atan(B.*alpha)) ) );

end
