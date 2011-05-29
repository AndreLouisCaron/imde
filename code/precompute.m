function [ R ] = precompute ( M, S, n )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % compute ratings.
    R = zeros(size(S,1), n);
    for i = 1 : size(S,1),
        R(i,:) = M(S(i,:));
    end
end
