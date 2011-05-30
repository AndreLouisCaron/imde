.. imde/api/mapping.rst
   Copyright 2011, Université de Sherbrooke

========
Mappings
========

Mappings project distortion parameters ``x`` into the quality space by
evaluating ``Q(f, g)`` where ``g=D(f, x)``.  They form the link between the
distortion function ``D(.)`` and the cost function used in the search process
by making the cost a function of the distortion parameters ``x``.

.. mat:current-toolbox:: imde

.. mat:function:: [ M ] = direct ( Q, D, f )

   Build a search-space to quality-space mapping that computes the distorted
   image ``g`` and evaluates the quality metric ``Q`` as ``Q(f, D(f,x))``.  This
   mapping is slow, but it is the most accurate and, theoretically speaking, the
   only reliable mapping.  All other mappings assume something about the mapped
   points, usually that they are projected onto a manifold.

   :param Q: quality metric (e.g. ``@ms_ssim``)
   :param D: distortion process (e.g. ``@camera_distortion``)
   :param f: clean input image
   :returns: ``M`` -- the search-space to quality-space mapping.

.. mat:function:: [ M ] = lookup ( N, R, I )

   Build a lookup mapping to accelerate a search-space to quality-space mapping.
   Use this when prototyping for quick assessment of how well a given process
   works.

   :param N: search-space distribution of points in ``R``
   :param R: set of quality-space ratings
   :param I: interpolation method (e.g. ``"@bilinear_interpolation"``)
   :returns: ``M`` -- the search-space to quality-space mapping.

   .. note:: Results are interpolated to prevent search procedures that use
      arbitrary floating-point coordinates from failing.  However, the precision
      in inherently limited by the precision of the input grid.

.. mat:function:: [ M, P ] = biqudratic_patch ( M, u, v )

   Approximate mapping ``M`` using a bi-quadratic patch.

   :param M: base mapping, usually direct or lookup
   :param u: patch control point parameter
   :param v: patch control point parameter
   :returns: ``M`` -- the new search-space to quality-space mapping;
             ``P`` -- 9 control points used to build the patch.

.. mat:function:: [ M, P ] = bicubic_patch ( M, u, v )

   Approximate mapping ``M`` using a bi-cubic patch.

   :param M: base mapping, usually direct or lookup
   :param u: patch control point parameter
   :param v: patch control point parameter
   :returns: ``M`` -- the new search-space to quality-space mapping;
             ``P`` -- 16 control points used to build the patch.

.. mat:function:: [ M ] = focus ( M, B )

   Parametric patches are very fast be they are also imprecise, especially as
   they cover large (e.g. the entire search space).  This function allows to
   build a new mapping that focuses on a localized area of the search space, and
   then building a patch that covers that area.

   It is typically used in the form ``P(focus(M, B))`` where ``P`` is
   :mat:fn:`bicubic_patch` or :mat:fn:`biquadratic_patch` and ``M`` is a
   :mat:fn:`direct` mapping.

   :param M: base mapping, usually direct or lookup
   :param B: search-space bounds
   :returns: ``M`` -- the new search-space to quality-space mapping;

   The search space bounds are specified as an ``N`` by ``2`` matrix where ``N``
   is the number of dimensions in the search space.  The first column gives the
   lower-bounds on each dimension and the 2nd column gives the upper bound on
   each dimension.

   .. warning:: Search results using the focused mapping are expressed in the
      focused mapping's search space, which means they must be projected back
      to the original search space using ``B``.
