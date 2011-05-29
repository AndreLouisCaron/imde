function [ m ] = focus ( M, B )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    m = @(x) M(B(:,1) + x'.*(B(:,2)-B(:,1)));
end
