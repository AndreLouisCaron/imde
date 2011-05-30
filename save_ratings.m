function [] = save_ratings ( q, d, f, N, R )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    ensure_existance = @(path) exist(path,'dir') || mkdir(path);
    ensure_existance(sprintf('./data/q/%s', q));
    ensure_existance(sprintf('./data/q/%s/%s', q, d));
    
    save(sprintf('./data/q/%s/%s/%s.mat', q, d, f), 'N', 'R'); unused(N, R);
end

function [] = unused ( varargin ); end
