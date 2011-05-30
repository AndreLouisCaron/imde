function [] = give_all_ratings ( q, d, N, k )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % compute ratings for each and every dataset.
    rate = @(f) ...
        give_ratings(q, d, f, N, k);
    cellfun(rate, list_datasets());
end
