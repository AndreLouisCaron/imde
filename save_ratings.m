function [] = save_ratings ( q, d, f, ratings )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    save(sprintf('./data/q/%s/%s/%s.mat', q, d, f), 'ratings'); unused(ratings);
end

function [] = unused ( varargin ); end
