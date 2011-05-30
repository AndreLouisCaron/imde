function [] = give_ratings ( q, d, f, N, k )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % resolve named parameters.
    Q = str2func(q);
    D = str2func(d);
    F = load_dataset(f);
    
      % compute the requested ratings.
    M = direct(Q, D, F);
    S = lattice(N);
    R = zeros(size(S,1), k);
    for i = 1 : size(S,1),
        R(i,:) = M(S(i,:));
    end
    
      % save them for lated.
    save_ratings(q, d, f, N, R);
end
