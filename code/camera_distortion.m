function [ g ] = camera_distortion ( f, x )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    g = gaussian_noise(gaussian_filter(f, x(1)), x(2));
end
