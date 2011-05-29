function [ h ] = msssim_dots ( R, a )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % color scheme.
    c = 1-R(:,1).*R(:,2).*R(:,3);
      % "existing & visible" or "new & invisible" figure.
    if exist('a','var'),
        h = get(a, 'parent');
    else
        h = figure('visible','off');
        a = axes('parent', h);
    end
      % plot points.
    scatter3(R(:,2), R(:,1), R(:,3), 50, c, '.', 'parent', a);
    ylabel(a, 'LD');
    xlabel(a, 'CD');
    zlabel(a, 'SD');
      % ajust viewpoint to emphasize manifold shape.
    axis(a, [0.5 1 0.9 1 0.3 1]);
    view(a, [-37.5 30]);
end
