function [ error ] = mean_estimation_error ( q, d, e, n )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    error = zeros(1,n);
    datasets = list_datasets();
    for i = 1 : numel(datasets),
        [N,E] = load_estimates(q, d, datasets{i}, e);
        for j = 1 : n,
            for k = 1 : size(E,1),
                error(end+1,j) = abs(E(k,j+n)-E(k,j));
            end
        end
    end
    error = mean(error(2:end,:), 1);
end
