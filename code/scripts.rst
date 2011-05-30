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

.. mat:function:: [ f ] = load_dataset ( name )

   Loads a dataset by name and returns the clean input image in its original
   format (usually an M-by-N-by-3 ``uint8`` matrix).

   :param name: dataset file name (e.g. ``"bikes.png"``)
   :returns: ``f`` -- the image

   The datasets are stored in ``./data/f/``.  The ``name`` parameter should
   correspond to a file in that folder.

.. mat:function:: [] = give_ratings ( q, d, f, N )

   :param q: quality metric name (e.g. ``"ms-ssim"``)
   :param d: distortion process name (e.g. ``"camera"``)
   :param f: dataset name (e.g. ``"bikes"``)

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
