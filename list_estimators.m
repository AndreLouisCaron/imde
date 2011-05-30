function [ listing ] = list_estimators ()
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    QP = @biquadratic_patch;
    CP = @bicubic_patch;
    S = lattice([15 15]);
    listing = {
      
        % brute force search.
      'bfs',    @(Q,D,f,M,T) brute_force(cost_function(    M,T), S)
      'bfs-qp', @(Q,D,f,M,T) brute_force(cost_function(QP(M),T), S)
      'bfs-cp', @(Q,D,f,M,T) brute_force(cost_function(CP(M),T), S)
      
        % simplex.
      'si',    @(Q,D,f,M,T) simplex(cost_function(    M,T), 2)
      'si-qp', @(Q,D,f,M,T) simplex(cost_function(QP(M),T), 2)
      'si-cp', @(Q,D,f,M,T) simplex(cost_function(CP(M),T), 2)
      
        % NewUOA.
      'nu',    @(Q,D,f,M,T) newuoa(cost_function(    M,T), 2)
      'nu-qp', @(Q,D,f,M,T) newuoa(cost_function(QP(M),T), 2)
      'nu-cp', @(Q,D,f,M,T) newuoa(cost_function(CP(M),T), 2)
      
        % Newton's method.
      'nt-qp', @(Q,D,f,M,T) newtons_method(M,T,QP)
      'nt-cp', @(Q,D,f,M,T) newtons_method(M,T,CP)
      
      };
end
