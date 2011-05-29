function [ h ] = msssim_mesh ( N, R, a )
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % specify which vertices to use for each face:
      %   -> MxN                    vertices;
      %   -> (N(1)-1)x(N(2)-1)      quads;
      %   -> (N(1)-1)x(N(2)-1) * 2  triangles.
    f = zeros(2*(N(1)-1)*(N(2)-1), 3, 'int32');
    for i = 1 : N(1)-1,
        for j = 1 : N(2)-1,
                % (i,j) (i,j+1), (i+1,j).
            f((i-1)*(N(1)-1)+j, :) = [
                (i-1)*N(1)+j (i-1)*N(1)+j+1 i*N(1)+j
                ];
                % (i,j+1) (i+1,j), (i+1,j+1).
            f((N(1)-1)*(N(2)-1)+((i-1)*(N(1)-1)+j), :) = [
                (i-1)*N(1)+j+1 i*N(1)+j i*N(1)+j+1
                ];
        end
    end
      % color scheme.
    c = zeros(N(1)*N(2), 1, 'double');
    c(:) = R(:,1) .* R(:,2) .* R(:,3);
    c(:) = 1 - c(:) / max(max(max(c)));
      % "existing & visible" or "new & invisible" figure.
    if exist('a','var'),
        h = get(a, 'parent');
    else
        h = figure('visible','off');
        a = axes('parent', h);
    end
      % put Y axis in 1st column.
    R(:,[1 2]) = R(:,[2 1]);
      % plot an empty scatter plots to show grid.
    scatter3([],[],[],100,'black');
      % Display triangles.
    hold(a, 'on');
      p = patch('Parent', a);
        set(p, 'Vertices', R);
        set(p, 'Faces', f);
        set(p, 'FaceVertexCData', c(:));
        set(p, 'FaceColor', 'interp');
        set(p, 'FaceAlpha', 0.50);
        set(p, 'EdgeColor', 'none');
    hold(a, 'off');
    axis(a, [0.5 1 0.9 1 0.3 1]);
    view(a, [-37.5 30]);
    xlabel(a, 'CD');
    ylabel(a, 'LD');
    zlabel(a, 'SD');
end
