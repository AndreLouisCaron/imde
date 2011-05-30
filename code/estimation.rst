.. imde/api/estimation.rst
   Copyright 2011, Université de Sherbrooke

:author: André Caron

==========
Estimation
==========

Different search methods are used in the image multi-distortion estimation
framework.

Examples
--------

.. _basic-session:

Basic session
~~~~~~~~~~~~~

The following is a stereotypical *complete* session demonstrating how to get
started with the framework.  Other code samples will be more focused and target
only parts of this process.

.. code-block:: matlab

   %
   % step 0: setup environment.
   %

     % move to project root folder.
   cd('path/to/imde');
   
     % make sure 'imde' functions can be found.
   addpath('./code/');
   
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
   
     % approximate distortion and quality assessment.
   P = @biquadratic_patch;
   M = P(direct(Q, D, f));
   
   %
   % step 2: attempt to retrieve 'x'
   %
   
     % define search target and cost function.
   T = Q(f, g);
   C = cost_function(M, T);
   
     % define search space.
   N = [10 10];
   S = lattice(N);
   
     % estimate x.
   y = brute_force(C, S);

Reference
---------   

.. mat:current-toolbox:: imde

.. mat:function:: [ x, c ] = brute_force ( C, S )

   The brute force search method is the straightforward discretization of the
   argmin operator: it evaluates the cost of every single point in a discrete
   version of the search space and selects the point with the lowest cost.

   :param C: cost function for optimizer
   :param S: search space
   :returns: ``x`` -- solution; ``c`` -- cost of solution ``x``.

   Example:

   .. code-block:: matlab

      >>   % estimation model.
      >> D = @camera; n = 2;
      >> Q = @msssim; k = 3;
      >>   % input images.
      >> f = load_dataset('bikes.png');
      >> x = [0.6 0.5];
      >> g = D(f, x);
      >>   % setup search method.
      >> T = Q(f, g);
      >> M = bicubic_patch(direct(Q, D, f));
      >> C = cost_function(M, T);
      >> N = [15 15];
      >> S = lattice(N);
      >>   % run the search!
      >> brute_force(C, S)
      ans =
          0.5714   0.6429

.. mat:function:: [ x, c ] = simplex ( C, n, K, x0 )

   The simplex algorithm is the classical solution to derivative-free
   optimization.  It maintains a ``n`` dimension triangle (simplex) and, at each
   iteration, attempts to move the vertex with the highest cost such that it
   becomes the vertex with the lowest cost at the next iteration.  When the
   maximum number of evalutions of ``C`` is exhausted, the coordinates of the
   vertex with the lowest cost is returned.

   :param C: cost function for optimizer
   :param n: number of distortion parameters
   :param K: optional maximum number of evalutions of ``C(.)``, 50 by default
   :param x0: optional starting point for search, defaults to ``0.5`` on all
              axes
   :returns: ``x`` -- solution; ``c`` -- cost of solution ``x``.

   Example:

   .. code-block:: matlab

      >>   % estimation model.
      >> D = @camera; n = 2;
      >> Q = @msssim; k = 3;
      >>   % input images.
      >> f = load_dataset('bikes.png');
      >> x = [0.6 0.5];
      >> g = D(f, x);
      >>   % setup search method.
      >> T = Q(f, g);
      >> M = direct(Q, D, f);
      >> C = cost_function(M, T);
      >>   % run the search!
      >> simplex(C, n)
      ans =
          0.6208   0.4014

.. mat:function:: [ x, c ] = [ x, c ] = newuoa ( C, n, K, x0 )

   Blah, blah, derivative-free optimizer, blah, blah...

.. mat:function:: [ x, c ] = newtons_method ( M, T, P, K, E )

   Newton's method is a derivative-based optimizer.  It requires the analytical
   development of the cost function and its two first derivatives.  Because
   these derivatives are typically not available, we use the derivatives of a
   patch that approximates the mapping.

   :param M: back-end mapping, usually :mat:fn:`direct`
   :param T: target point ``T=Q(f,g)``
   :param P: patch function (:mat:fn:`biquadratic_patch` or
             :mat:fn:`bicubic_patch`)
   :param K: optional limit on the number of iterations, defaults to 50
   :param E: optional limit on the minimal improvement for one axis, defaults
             to 0.0001
   :returns: ``x`` -- solution; ``c`` -- cost of solution ``x``.

   ``E`` specifies a minimum improvement bound.  If at any iteration, no single
   parameter was modified by at least this amount, the optimization is
   considered to have converged and the method returns right away.  This means
   there may be less than ``K`` iterations in totoal.

   Example:

   .. code-block:: matlab

      >>   % estimation model.
      >> D = @camera; n = 2;
      >> Q = @msssim; k = 3;
      >>   % input images.
      >> f = load_dataset('bikes.png');
      >> x = [0.6 0.5];
      >> g = D(f, x);
      >>   % setup search method.
      >> T = Q(f, g);
      >> M = direct(Q, D, f);
      >>   % run the search!
      >> newtons_method(M, T, @bicubic_patch)
      ans =
          0.6056   0.5159

.. mat:function:: [ x, c ] = refined_patches ( M, P, search, n, T, r, k )

   Builds a parametric patch that spans the entire search space and runs the
   selected search procedure to build an initial estimate of the solution.
   Then, the solution is iteratively refined by building smaller and smaller
   patches around the solution at the previous iteration.

   :param M: back-end mapping, usually :mat:fn:`direct`
   :param P: constructor for the parametric patch
   :param search: search procedure used at each refinement
   :param n: number of distortion parameters
   :param T: target point in the search space
   :param r: reduction of search space at each refinement
   :param k: number of refinements, defaults to 2
   :returns: ``x`` -- solution; ``c`` -- cost of solution ``x``.

   The number of dimensions is required to build the initial search bounds.  It
   is specified in the argument ``n`` because it cannot be inferred by the
   search procedure.
