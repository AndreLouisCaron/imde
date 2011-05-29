function [ M, P, p, d ] = bicubic_patch ( M, u, v )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
        % Control points are evenly spaced by default.
    if ~exist('u','var'), u = 1/3; end
    if ~exist('v','var'), v = 2/3; end
        % Build a list of control points.
    p = [[0; 0] [u; 0] [v; 0] [1; 0] ...
         [0; u] [u; u] [v; u] [1; u] ...
         [0; v] [u; v] [v; v] [1; v] ...
         [0; 1] [u; 1] [v; 1] [1; 1]]';
    P = zeros(size(p,1), 3);
    for i = 1 : size(p,1),
        P(i,:) = M(p(i,:));
    end
        % Build spline matrix.
    B = inv([
        1   0   0   0;
        1   u u^2 u^3;
        1   v v^2 v^3;
        1   1   1   1;
        ]);
        % Return a projection function, control points and derivatives.
    M = @(x) f(P, B, x(1), x(2));
    d = {@(x) ds1(P,B,x(1),x(2)) @(x) ds2(P,B,x(1),x(2));
         @(x) dt1(P,B,x(1),x(2)) @(x) dt2(P,B,x(1),x(2))};
end

  % Utility projection function: projects one point.
function [ x ] = project ( P, B, S, T )
    SB = S * B;
    SBP(1,:) = SB(1)*P( 1,:) +SB(2)*P( 2,:) +SB(3)*P( 3,:) +SB(4)*P( 4,:);
    SBP(2,:) = SB(1)*P( 5,:) +SB(2)*P( 6,:) +SB(3)*P( 7,:) +SB(4)*P( 8,:);
    SBP(3,:) = SB(1)*P( 9,:) +SB(2)*P(10,:) +SB(3)*P(11,:) +SB(4)*P(12,:);
    SBP(4,:) = SB(1)*P(13,:) +SB(2)*P(14,:) +SB(3)*P(15,:) +SB(4)*P(16,:);
    x = SBP' * B' * T'; x = x';
end

  % original function.
function [ x ] = f ( P, B, s, t )
    x = project(P, B, [1 s s^2 s^3], [1 t t^2 t^3]);
end

  % 1st derivative along 1st dimension.
function [ x ] = ds1 ( P, B, s, t )
    x = project(P, B, [0 1 2*s 3*s^2], [1 t t^2 t^3]);
end

  % 2nd derivative along 1st dimension.
function [ x ] = ds2 ( P, B, s, t )
    x = project(P, B, [0 0 2 6*s], [1 t t^2 t^3]);
end

  % 1st derivative along 2nd dimension.
function [ x ] = dt1 ( P, B, s, t )
    x = project(P, B, [1 s s^2 s^3], [0 1 2*t 3*t^2]);
end

  % 2nd derivative along 2nd dimension.
function [ x ] = dt2 ( P, B, s, t )
    x = project(P, B, [1 s s^2 s^3], [0 0 2 6*t]);
end
