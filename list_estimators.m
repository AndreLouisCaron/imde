function [ listing ] = list_estimators ()
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    BP = @biquadratic_patch;
    CP = @bicubic_patch;
    listing = {
      'bfs', @(Q,D,f,M,T) brute_force(...
          cost_function(M,T), lattice([15 15]))
          
      'bfs-qp', @(Q,D,f,M,T) brute_force(...
          cost_function(BP(M),T), lattice([15 15]))
          
      'bfs-cp', @(Q,D,f,M,T) brute_force(...
          cost_function(CP(M),T), lattice([15 15]))

      'si', @(Q,D,f,M,T) simplex(...
          cost_function(CP(M),T), 2)

      'si-qp', @(Q,D,f,M,T) simplex(...
          cost_function(CP(M),T), 2)

      'si-cp', @(Q,D,f,M,T) simplex(...
          cost_function(CP(M),T), 2)

      'nu', @(Q,D,f,M,T) newuoa(...
          cost_function(CP(M),T), 2)

      'nu-qp', @(Q,D,f,M,T) newuoa(...
          cost_function(CP(M),T), 2)

      'nu-cp', @(Q,D,f,M,T) newuoa(...
          cost_function(CP(M),T), 2)
      };
end
