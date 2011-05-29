function [ x, c ] = refined_patch_search ( M, P, search, n, T, r, k )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % default to 2 refinements and 75% reduction in each direction.
    if ~exist('k','var'), k = 2;    end
    if ~exist('r','var'), r = 0.25; end
      % start off with entire search space.
    B = [zeros(n,1) ones(n,1)];
      % find initial estimate.
    m = P(focus(M,B));
    x = search(m, T);
      % for each refinement,
    for i = 1 : k,
          % reduce search space.
        delta = r * 0.5 * (B(:,2) - B(:,1));
        B(:,1) = max(x' - delta, B(:,1));
        B(:,2) = min(x' + delta, B(:,2));
          % search inside localized patch.
        m = P(focus(M,B));
        x = search(m, T);
          % account for modification of search bounds.
        x = B(:,1) + x'.*(B(:,2)-B(:,1)); x = x';
    end
      % compute cost of solution.
    C = cost_function(M, T);
    c = C(x);
end
