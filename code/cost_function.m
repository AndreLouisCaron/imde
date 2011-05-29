function [ C ] = cost_function ( M, T )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    C = @(x) distance(M, T, x);
end

function [ d ] = distance ( M, T, x )
      % Brutally enforce search bounds.
    if (min(x) < 0) || (max(x) > 1) || any(isnan(x)),
        d = Inf; return;
    end
      % Compute distance in SSIM space.
    d = sqrt(sum((T - M(x)).^2));
end
