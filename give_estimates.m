function [] = give_estimates ( q, d, f, n, k, e )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % resolve named parameters.
    Q = str2func(q);
    D = str2func(d);
    F = load_dataset(f);
    E = find_estimator(e);
    
    %m = direct(Q, D, F);
    
      % compute the requested ratings.
    [N, R] = load_ratings(q, d, f);
    I = @bilinear_interpolation;
    M = lookup(N, R, I);
    
    S = lattice(n);
    estimates = zeros(size(S,1), 2*k);
    for i = 1 : size(S,1),
        T = M(S(i,:));
        estimate = E(Q,D,F,M,T);
        estimates(i,:) = [S(i,:) estimate];
    end
    
      % save them for lated.
    save_estimates(q, d, f, e, N, estimates);
end
