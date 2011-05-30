function [ N, R ] = load_ratings ( q, d, f )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    N = []; R = []; load(sprintf('./data/q/%s/%s/%s.mat', q, d, f), 'N', 'R');
end
