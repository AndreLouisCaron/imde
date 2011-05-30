function [ x, c ] = newtons_method ( M, T, P, K, E )
    % Copyright(c) André Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % by default, evaluate the function at most 50 times and
      % stop if there is no axis for which increment is at least 0.0001.
    if ~exist('K','var'), K = 50;     end
    if ~exist('E','var'), E = 0.0001; end
      % function derivatives are unknown, so approximate
      % it with a patch and use the patch's derivatives.
    [f, R, p, d] = P(M);
      % number of search parameters.
    n = size(d,1);
      % make an educated guess about the solution's location
      %  based on its proximity to the patch's control points.
    distances = arrayfun(@(k)sum((R(k,:)-T).^2), 1:size(R,1));
    [distances,order] = sort(distances);
    distances(distances==0) = eps;
    weight = 1 ./ distances(order(1:2));
    weight = weight / sum(weight);
    points = p(order(1:2),:);
    x = weight * points;
      % iteratively increase the quality of the solution.
    for i = 1 : K,
          % make smaller jumps as we get closer.
        delta = f(x) - T;
          % find next point.
        next = x;
        for k = 1 : n,
              % estimate next position on current axis.
            d1 = d{k,1}(x);
            d2 = d{k,2}(x);
            candidate = x(k) - (sum(delta.*d1) / sum(d1.^2+delta.*d2));
              % stay in search bounds.
            if (candidate >= 0) && (candidate <= 1),
                next(k) = candidate;
            end
        end
          % stop early if precision doesn't increase enough.
        stop = sum(abs(next-x)>E) < 1;
          % start next iteration with best results.
        x = next;
          % can't stick this in for loop.
        if stop, break; end
    end
      % estimate the solution's cost.
    c = sum((f(x)-T).^2);
end
