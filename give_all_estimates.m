function [] = give_all_estimates ( q, d, N, k, e )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % compute ratings for each and every dataset.
    estimate = @(f) ...
        give_estimates(q, d, f, N, k, e);
    cellfun(estimate, list_datasets());
end
