.. imde/api/distortion.rst
   Copyright 2011, Université de Sherbrooke

:author: André Caron

==========
Distortion
==========

High-level processes
--------------------

A high-level distortion process is a multi-parameter distortion process.  It
serves as a case study for the image multi-distortion estimation framework.

.. mat:current-toolbox:: imde

.. mat:function:: [ g ] = camera ( f, x )

   Distorts ``f`` using the common model for image acquisition in digital
   cameras:

   .. math::

      g =& D(f; \theta) \\
        =& D(f; \alpha, \beta) \\
        =& h_\alpha * f + N_\beta,

   where :math:`h_\alpha` is a Gaussian filter of parameter :math:`\alpha` and
   :math:`N_\beta` is zero-mean Gaussian noise of variance :math:`\beta`.

   :param f: clean input image
   :param x: distortion parameters :math:`\theta`
   :returns: ``g`` -- distorted version of ``f``.

Low-leve processes
------------------

A low-level distortion process is a single-parameter distortion process.  It
usually serves as a building block for one of the higher-level distortion
processes.

.. mat:current-toolbox:: imde

Blur
~~~~

.. mat:function:: [ g ] = gaussian_filter ( f, x )

   :param f: clean input image
   :param x: filter size
   :returns: ``g`` --  distorted version of ``f``

Noise
~~~~~

.. mat:function:: [ g ] = gaussian_noise ( f, x )

   :param f: clean input image
   :param x: filter size
   :returns: ``g`` -- distorted version of ``f``
