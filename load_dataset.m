function [ f ] = load_dataset ( name )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    f = imread(strcat('./data/f/', name));
end
