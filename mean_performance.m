function [ performance ] = mean_performance ( q, d, e, n )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    performance = zeros(0,n+1);
    datasets = list_datasets();
    for i = 1 : numel(datasets),
          % compute results for the current dataset.
        [N,E] = load_estimates(q, d, datasets{i}, e);
        round = zeros(size(E,1),n+1);
        for k = 1 : size(E,1),
            for j = 1 : n,
                round(k,j) = abs(E(k,j+n)-E(k,j));
            end
            round(k,n+1) = E(k,2*n+1);
        end
          % cumulate results.
        performance = [performance; round];
    end
    performance = mean(performance(2:end,:), 1);
end
