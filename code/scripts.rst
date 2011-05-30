.. imde/scripts.rst
   Copyright 2011, Université de Sherbrooke

=======
Scripts
=======

This section describes functions that are not part of the image multi-distortion
estimation framework, but help with workflow.

Reference
---------

.. mat:current-toolbox:: imde

.. mat:function:: [ listing ] = list_datasets ()

   This function makes a listing of image files in the ``./data/f/`` folder.

   :returns: a cell array in which each element is suitable for a call to
             :mat:fn:`load_dataset`.

.. mat:function:: [ f ] = load_dataset ( name )

   Loads a dataset by name and returns the clean input image in its original
   format (usually an M-by-N-by-3 ``uint8`` matrix).

   :param name: dataset file name (e.g. ``"bikes.png"``)
   :returns: ``f`` -- the image

   The datasets are stored in ``./data/f/``.  The ``name`` parameter should
   correspond to a file in that folder.

.. mat:function:: [] = give_ratings ( q, d, f, N, k )

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)
   :param k: number of output components for ``q`` (dimensions of quality
             metric space)

   This function uses :mat:fn:`save_ratings` to persist the results, they are
   not returned to the caller.

   Example:

   .. code-block:: matlab

      >>  % pre-compute a high-resolution grid for estimation.
      >>  % warning: this will take a long time to run...
      >> give_ratings('ms-ssim', 'camera', 'bikes.png', [50 50]);

.. mat:function:: [] = save_ratings ( q, d, f, N, R )

   Persist settings for later re-use as in a lookup mapping.  Lookup mappings
   save considerable amount of time when experimenting with the framework.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)
   :param N:
   :param R:
   :returns: ``f`` -- the image

   The datasets are stored in ``./data/r/<q>/<d>/<f>.mat``.

.. mat:function:: [ N, R ] = load_ratings ( q, d, f )

   Loads a pre-computed set of ratings.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)
   :returns: ``R`` -- the ratings, ``N`` the grid layout.

   The datasets are stored in ``./data/r/<q>/<d>/<f>.mat``.

   Example:

   .. code-block:: matlab

      >> [N, R] = load_ratings('ms-ssim', 'camera', 'bikes.bmp');
      >> M = lookup(N, R, @bilinear_interpolation);

.. mat:function:: [] = give_all_ratings ( q, d, N, k )

   Computes ratings for each dataset.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param k: number of output components for ``q`` (dimensions of quality
             metric space)

   This function uses :mat:fn:`save_ratings` to persist the results, they are
   not returned to the caller.

   Example:

   .. code-block:: matlab

      >>  % pre-compute a high-resolution grid for estimation.
      >>  % warning: this will take a long time to run...
      >> give_ratings('ms-ssim', 'camera', 'bikes.png', [50 50]);

.. mat:function:: [] = save_estimates ( q, d, f, e, N, E )

   Saves estimates for a given dataset, estimator pair.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)
   :param e: estimator name (e.g. ``"bfs"``)
   :param N: estimation grid shape
   :param E: estimates

.. mat:function:: [ N, E ] = load_estimates ( q, d, f, e )

   Loads estimates for a given dataset, estimator pair.  This is used
   extensively by the results analysis phase.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)
   :param e: estimator name (e.g. ``"bfs"``)
   :returns: ``E`` -- the estimates, ``N`` -- esimation grid shape.

.. mat:function:: [] = give_estimates ( q, d, f, n, k, e )

   Runs a given estimation process on a single dataset.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)
   :param n: estimation grid shape
   :param k: number of estimation parameters
   :param e: estimator name (e.g. ``"bfs"``)

.. mat:function:: [] = give_all_estimates ( q, d, N, k, e )

   Runs the same estimation process on all datasets.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param N: estimation grid shape
   :param k: number of estimation parameters
   :param e: estimator name (e.g. ``"bfs"``)

.. mat:function:: [ performance ] = mean_performance ( q, d, e, n )

   Computes the mean estimation error for the selected estimator on each of the
   ``n`` estimation parameters, as well as the mean runtime.  The average is
   performed over all datasets.

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param e: estimator name (e.g. ``"bfs"``)
   :param n: number of estimation parameters
   :returns: ``performance`` -- a vector of ``n+1`` components

   The ``performance`` vector is formatted as the mean error on each of the
   ``n`` components, followed by the mean runtime for the method.
