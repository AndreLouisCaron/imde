function [ g ] = gaussian_filter ( f, x )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
        % De-normalize filter variance.
    x = 0.1 + x * (20-0.1);
        % Create separable filter, minimum 3x3.
    half = max(ceil(x*3/2-1), 3);
    h = pdf('Normal', -half:+1:+half, 0, x);
    h = h / sum(h);
        % Distort image.
    g = imfilter(imfilter(f, h), h');
end
