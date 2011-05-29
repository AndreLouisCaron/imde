function [ g ] = gaussian_noise ( f, x )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
        % De-normalize noise x.
    x = 0.0001 + x * (0.01-0.0001);
        % Distort f.
    g = imnoise(uint8(f), 'gaussian', 0, x);
end
