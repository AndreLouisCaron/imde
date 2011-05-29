function [ x, c ] = simplex ( C, n, K, x0 )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % default to 50 evalutions, start in the middle of the search space.
    if ~exist('K' ,'var'), K  = 50;                end
    if ~exist('x0','var'), x0 = repmat(0.5,[1 n]); end
      % use MATLAB's builtin simplex optimizer.
    [x, c] = fminsearch(C, x0, optimset('MaxFunEvals', K, 'Display', 'off'));
end
