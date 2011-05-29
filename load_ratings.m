function [ ratings ] = load_ratings ( q, d, f )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    ratings = []; load(sprintf('./data/q/%s/%s/%s.mat', q, d, f), 'ratings');
end
