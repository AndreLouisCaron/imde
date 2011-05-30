.. imde/api/plotting.rst
   Copyright 2011, Université de Sherbrooke

:author: André Caron

========
Plotting
========

The plotting functions help in getting familiar with the data...

All functions accept an optional axes handle.  This parameter is really useful
when using `subplot(.)`_ to make groups of related figures.

.. _`subplot(.)`: http://www.mathworks.com/help/techdoc/ref/subplot.html

These functions were designed to generate many figures using scripts which uses
MATLAB's built-in `saveas(.)`_ function to output images files, so they don't
show the figure by default.  If you would like to save the figure, proceed as
follows:

.. code-block:: matlab

   h = msssim_scatter(...);
   set(h, 'visible', 'on');

.. _`saveas(.)`: http://www.mathworks.com/help/techdoc/ref/saveas.html

Examples
--------

Plotting MS-SSIM ratings
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: matlab

   %
   % step 1: prepare data.
   %
   
     % estimation model.
   D = @camera; n = 2;
   Q = @msssim; k = 3;
   
     % distortion parameters.
   x = [0.198 0.439];
   
     % input images.
   f = load_dataset('bikes.png');
   g = D(f, x);
   
     % map distortion parameters to search space by
     % distorting the image and assessing quality.
   M = direct(Q, D, f);
   
     % compute a bunch of distortion ratings.
     %   (warning, this is bit is slow...)
   N = [10 10];
   S = lattice(N);
   R = precompute(M, S, k);
   
   %   
   % step 2: plot results!
   %
   
     % as a scatter plot (dots):
   h = msssim_dots(R);
   set(h, 'visible', 'on');
   
     % as a surface plot (mesh):
   h = msssim_mesh(N, R);
   set(h, 'visible', 'on');

Reference
---------

.. mat:current-toolbox:: imde

.. mat:function:: [ h ] = msssim_dots ( N, R, a )

   :param R: list of MS-SSIM ratings
   :param a: optional handle to the axes in which the plot will be rendered
   :returns: ``h`` --  figure handle

.. mat:function:: [ h ] = msssim_mesh ( N, R, a )

   Plot the surface corresponding to the manifold formed by projection of a grid
   of distortion parameters into the quality space.

   :param N: true shape of ``R``
   :param R: list of MS-SSIM ratings used as the mesh vertices
   :param a: optional handle to the axes in which the plot will be rendered
   :returns: ``h`` --  figure handle
