function [ x, c ] = brute_force ( C, S )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % Compute the cost at each point in the space.
    c = Inf; x = 0;
    for i = 1 : size(S,1),
        cost = C(S(i,:));
          % Keep track of point with lowest cost.
        if cost < c,
            c = cost; x = i;
        end
    end
      % Recover parameters associated to point with the lowest cost.
    x = S(x,:);
end
