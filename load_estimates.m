function [ N, E ] = load_estimates ( q, d, f, e )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    N = []; E = [];
    load(sprintf('./data/e/%s/%s/%s/%s.mat', q, d, e, f), 'N', 'E');
end
