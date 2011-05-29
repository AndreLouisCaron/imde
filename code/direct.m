function [ M ] = direct ( Q, D, f )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
        % Return a projection function.
    M = @(x) Q(f, D(f, x));
end
