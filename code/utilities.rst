.. imde/api/utilities.rst
   Copyright 2011, Université de Sherbrooke

:author: André Caron

=========
Utilities
=========

.. mat:current-toolbox:: imde

.. mat:function:: [ S ] = lattice ( N )

   Build a list of points for evaluation...

   :param N: number of samples on each axis
   :returns: ``S`` -- list of points in search space

   ``N`` is formatted as a (row or column) vector of positive integers
   specifying the number of samples to take on each axis.  It must have one
   component for each parameter in the distortion process.

   ``S`` is formatted as a matrix where each row contains the normalized
   coordinates of the point in the search space.

   .. note::

      You should keep the layout ``N`` handy as some (plotting) functions
      require it to interpret the list of points.

.. mat:function:: [ C ] = cost_function ( M, T )

   Build a cost function using a mapping and a target point in the
   quality-metric space.  For a candidate set of distortion parameters ``x``, it
   attempts to evaluate how far ``x`` is from ``T``, the set of parameters used
   to generate the distorted image ``g`` as in ``T=Q(f,g)``.

   The cost is the euclidian distance from ``M(x)`` to ``T``.  If ``x`` is
   outside of the search space -- that is, if any component of ``x`` is smaller
   than 0 or greater than 1 --, ``Inf`` is returned to ensure that solution is
   never picked.

   :param M: search-space to quality-space mapping
   :param T: search target, ``Q(f,g)``
   :returns: ``C`` -- a function of ``x``.

.. mat:function:: [ r ] = bilinear_interpolation ( grid, x )

   Interpolation is used for making a grid of pre-computed points as though it
   had infinite resolution.  This is very useful when prototyping, where we
   typically pre-compute many distortions of ``f``.

   :param grid: grid of simple points between which to interpolate
   :param x: real-valued coordinates
   :returns: ``r`` --  interpolated rating for coordinates ``x``

   .. warning::

      Never use such interpolated mappings for results you intend to publish.
      When performing "official" benchmarks, always use the direct mapping to
      ensure no smoothing biased is introduced.
