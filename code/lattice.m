function [ S ] = lattice ( N )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % appearance statistics.
    r = [1 cumprod(N(1:end-1))];
    f = cumprod(N);
    c = prod(N) ./ f;
      % store coordinates.
    S = zeros(prod(N), numel(N));
    for i = 1 : numel(N),
        range = (0:N(i)-1) / (N(i)-1);
        S(:,i) = repmat(expand(range,r(i)),[1 c(i)])';
    end
end

function y = expand ( b, m ) 
    %
    y = reshape(repmat(b',1,m)', length(b(:,1)), m*length(b(1,: )));
end
