function [ M, P, p, d ] = biquadratic_patch ( M, u )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % Control points are evenly spaced by default.
    if ~exist('u','var'), u = 1/2; end
      % Build a list of control points.
        % Build a list of control points.
    p = [[0; 0] [u; 0] [1; 0] ...
         [0; u] [u; u] [1; u] ...
         [0; 1] [u; 1] [1; 1]]';
    P = zeros(size(p,1), 3);
    for i = 1 : size(p,1),
        P(i,:) = M(p(i,:));
    end
      % Build spline matrix.
    B = inv([
        1 0    0;
        1 u u.^2;
        1 1    1;
        ]);
        % Return a projection function, control points and derivatives.
    M = @(x) f(P, B, x(1), x(2));
    d = {@(x) ds1(P,B,x(1),x(2)) @(x) ds2(P,B,x(1),x(2));
         @(x) dt1(P,B,x(1),x(2)) @(x) dt2(P,B,x(1),x(2))};
end

  % Utility projection function: projects one point.
function [ x ] = project ( P, B, S, T )
    SM = S * B;
    SMG(1,:) = SM(1)*P(1,:) + SM(2)*P(2,:) + SM(3)*P(3,:);
    SMG(2,:) = SM(1)*P(4,:) + SM(2)*P(5,:) + SM(3)*P(6,:);
    SMG(3,:) = SM(1)*P(7,:) + SM(2)*P(8,:) + SM(3)*P(9,:);
    x = SMG' * B' * T'; x = x';
end

  % original function.
function [ x ] = f ( P, B, s, t )
    x = project(P, B, [1 s s^2], [1 t t^2]);
end

  % 1st derivative along 1st dimension.
function [ x ] = ds1 ( P, B, s, t )
    x = project(P, B, [0 1 2*s], [1 t t^2]);
end

  % 2nd derivative along 1st dimension.
function [ x ] = ds2 ( P, B, s, t )
    x = project(P, B, [0 0 2], [1 t t^2]);
end

  % 1st derivative along 2nd dimension.
function [ x ] = dt1 ( P, B, s, t )
    x = project(P, B, [1 s s^2], [0 1 2*t]);
end

  % 2nd derivative along 2nd dimension.
function [ x ] = dt2 ( P, B, s, t )
    x = project(P, B, [1 s s^2], [0 0 2]);
end
