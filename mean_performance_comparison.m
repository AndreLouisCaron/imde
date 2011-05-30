function [ h ] = mean_performance_comparison ( q, d, n )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % gather all results.
    estimators = list_estimators();
    performance = zeros(size(estimators,1), n+1, 2);
    for i = 1 : size(estimators,1),
        performance(i,:,:) = mean_performance(q, d, estimators{i,1}, n);
    end
      % select labels.
    labels = estimators(:,1);
      % render figure.
    h = figure('Visible', 'Off');
    set(h, ...
        'DefaultAxesFontSize',   12.0, ...
        'DefaultAxesLineWidth',   0.7, ...
        'DefaultLineLineWidth',   0.8, ...
        'DefaultPatchLineWidth',  0.7);
    for i = 1 : n,
        subplot(n+1, 1, i);
        parameter(squeeze(performance(:,i,:)), labels(:,1));
    end
    subplot(n+1, 1, n+1);
    runtime(squeeze(performance(:,n+1,:)), labels(:,1));
end

function [] = parameter ( p, labels )
    p = 100 * p;
    bar(p); maxp = 50;
    title('Blur estimation error');
    legend('Mean', 'Stddev');
    set(gca, 'XTickLabel', labels);
    set(gca, 'ylim', [0 maxp]);
    for i = 1 : size(p,1),
        label = strcat(num2str(p(i,1),'%3.2f'),'%');
        height = min(p(i,1),maxp)+0.05*maxp;
        text(i-0.13, height, label, ...
            'HorizontalAlignment', 'center', 'FontSize', 8);
        label = strcat(num2str(p(i,2),'%3.2f'),'%');
        height = min(p(i,2),maxp)+0.05*maxp;
        text(i+0.19, height, label, ...
            'HorizontalAlignment', 'center', 'FontSize', 8);
    end
    ylabel('Accuracy (% of \alpha_{MAX})');
end

function [] = runtime ( r, labels )
    bar(r); maxrt = 100;
    title('Mean estimation runtime');
    set(gca, 'XTickLabel', labels);
    set(gca, 'ylim', [0 maxrt]);
    for i = 1 : length(r),
        label = num2str(r(i),'%3.2f');
        height = min(r(i),maxrt)+0.05*maxrt;
        text(i, height, label, ...
            'HorizontalAlignment', 'center', 'FontSize', 8);
    end
    ylabel('Runtime (seconds)');
end
