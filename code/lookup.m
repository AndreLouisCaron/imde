function [ M ] = lookup ( N, P, I )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    M = @(x) access(x, N, P, I);
end

  % Map each request to the closest pre-computed result.
function [ x ] = access ( x, N, P, I )
    %
      % map normalized coordinates to indices.
    k = 1 + x.*(N-1);
      % index in the pre-computed grid.
    x = zeros(1, size(P,2));
    for i = 1 : size(P,2),
        x(i) = I(reshape(P(:,i),N), k);
    end
end
