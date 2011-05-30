function [] = save_estimates ( q, d, f, e, N, E )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    ensure_existance = @(path) exist(path,'dir') || mkdir(path);
    ensure_existance(sprintf('./data/e/%s', q));
    ensure_existance(sprintf('./data/e/%s/%s', q, d));
    ensure_existance(sprintf('./data/e/%s/%s/%s', q, d,e ));
    
    unused(N, E);
    save(sprintf('./data/e/%s/%s/%s/%s.mat', q, d, e, f), 'N', 'E');
end

function [] = unused ( varargin ); end
