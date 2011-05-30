function [ e ] = find_estimator ( name )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
    estimators = list_estimators();
    for i = 1 : size(estimators,1),
        estimator = estimators(i,:);
        if strcmp(estimator{1},name),
            e = estimator{2}; return;
        end
    end
    error('Estimator not found.');
end
