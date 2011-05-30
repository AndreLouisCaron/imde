function [ y ] = bilinear_interpolation ( grid, x )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
        % Coordinates for 4 corners and offset to top-left.
    i = floor(x(1)); x(1) = x(1) - i; ip1 = min(i+1, size(grid,1));
    j = floor(x(2)); x(2) = x(2) - j; jp1 = min(j+1, size(grid,2));
    
        % Blend values at 4 coordinates based on distance to corners.
    y = (1-x(2)) * ((1-x(1))*grid(i  ,j  ) + (0+x(1))*grid(ip1,j  )) +...
        (0+x(2)) * ((1-x(1))*grid(i  ,jp1) + (0+x(1))*grid(ip1,jp1));
end
