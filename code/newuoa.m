function [ x, c ] = newuoa ( C, n, K, x0 )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
        % Provide default limit for the number of points.
    if ~exist('K','var'), K = 50;            end
    if ~exist('E','var'), E = [0.25 0.0001]; end
    if ~exist('x0','var'), x0 = repmat(0.5,[1 n]); end
        % Use C++/C/Fortran optimizer.
    x = mnewuoa(C, x0, E, K);
    c = 0;
end
