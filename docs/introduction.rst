.. imde/introduction.rst
   Copyright 2011, Université de Sherbrooke

============
Introduction
============

Problem Definition
------------------

Image multi-distortion estimation is a framework for objective, qualitative
recovery of the parameters used to distort an image.  That is, given a
distortion operator :math:`D(I;\theta)` and two images :math:`f` and
:math:`g=D(f;\theta)`, the goal is to recover :math:`\theta`.  In the past,
methods have been proposed for specific distortion operators, and all of them
focus on the case where :math:`\theta` is a scalar.  This project defines a
framework for recovery of :math:`\theta` when :math:`D(.)` has multiple
parameters.  Moreover, the solution is defined in terms that don't rely on the
exact definition of :math:`\theta`, such that the form can be re-used for
multiple distortion operators.

The problem poses several challenges:

#. :math:`D(.)` usually has a very cumbersome definition, making it hard or even
   impossible to invert;
#. the analytical inverse of :math:`D(.)` can hardly be re-used, and this
   difficult problem must be repeated for each new :math:`D(.)`;
#. :math:`D(.)` is often a function of multiple parameters and they must be
   estimated jointly.

+-------------------------------------+---------------------------------------+
|                     Sample input images (click to enlarge)                  |
+=====================================+=======================================+
|                                     |                                       |
| .. figure:: static/f.png            | .. figure:: static/g.png              |
|     :width: 768                     |    :width: 768                        |
|     :height: 512                    |    :height: 512                       |
|     :scale: 40%                     |    :scale: 40%                        |
|     :align: center                  |    :align: center                     |
|     :alt: Clean input image "f".    |    :alt: Distorted input image "g".   |
|                                     |                                       |
|     Clean image :math:`f`           |    Distorted image :math:`g`,         |
|                                     |    :math:`\theta=(0.590,0.400)`       |
|                                     |                                       |
+-------------------------------------+---------------------------------------+

Our framework formulates the problem of recovering :math:`\theta` from :math:`f`
and :math:`g` as an optimization problem.  Using the MS-SSIM image quality
metric, we define a simple cost function for this optimization problem.  This
cost function allows to determine how close a candidate
:math:`\hat{g}=D(f;\hat{\theta})` is to :math:`g`.  This proves to be a very
efficient solution when the guess is sufficiently "good".  In practice, this is
not too hard.

Different approaches are used to improve how "good" the guess is, reducing the
number of candidates (and therefore evalutions of the expensive :math:`D(.)`)
required to find a good match.


Datasets
========

The 59 images used for testing our method are publicly available and can be used
for comparison in your own publications.  If you develop a competing approach,
please use these images from the same dataset and compare the results with those
presented in our papers.

Half of the test images were selected from the LIVE Image Quality Assessment
Database, which was used in the studys for the development of the MS-SSIM image
quality metric.  The other half of the test images were selected from the Corel
image database, which is used for development of content-based image retrieval
methods.


#. **H.R. Sheikh, Z.Wang, L. Cormack and A.C. Bovik**, "LIVE Image Quality
   Assessment Database Release 2"
   http://live.ece.utexas.edu/research/quality/subjective.htm
#. Corel image database: http://wang.ist.psu.edu/docs/related/

Due to copyright restrictions, we do not distribute the images taken from these
datasets.  Please refer to the databases' respective websites for free download.


Results
=======

We present here a quick overview of the method's capabilities.  The following
results are obtained from use of our method to recover parameters of the digital
camera distortion model

.. math::

   g =& D(f; \alpha, \beta) \\
     =& h_\alpha * f + N_\beta,

where :math:`h_\alpha` is a Gaussian filter of parameter :math:`\alpha` and
:math:`N_\beta` is zero-mean Gaussian noise of variance :math:`\beta`.

Please refer to the full papers for complete results analysis, including results
for multiple distortion types and demonstration of convergeance of the
optimization process.

Sample Result
-------------

The following is a typical result obtained from use of our method to recover
parameters.  The image :math:`\hat{g}=D(f;\hat{\alpha},\hat{\beta})` on the
right is recovered from distorting the input image :math:`f` with the parameters
:math:`\hat{\theta}=(\hat{\alpha},\hat{\beta})` estimated from :math:`f` and
:math:`g`.

+-------------------------------------+---------------------------------------+
|                     Distorted images (click to enlarge)                     |
+=====================================+=======================================+
|                                     |                                       |
| .. figure:: static/g.png            | .. figure:: static/h.png              |
|     :width: 768                     |    :width: 768                        |
|     :height: 512                    |    :height: 512                       |
|     :scale: 40%                     |    :scale: 40%                        |
|     :align: center                  |    :align: center                     |
|     :alt: Input image "g".          |    :alt: Result image "h".            |
|                                     |                                       |
|     Distorted image :math:`g`,      |    Distorted image :math:`\hat{g}`,   |
|     :math:`\theta=(0.590,0.400)`    |    :math:`\hat{\theta}=(0.583,0.416)` |
|                                     |                                       |
+-------------------------------------+---------------------------------------+

Parameter values are given in the :math:`[0,1]` interval where 0 indicates no
distortion and 1 indicates the maximum allowable parameter value.  The results
thus show a 1.7% and 1.6% error on blur and noise levels, respectively.

Benchmarks
----------

The following presents global performance comparison of presented algorithms for
estimation of blur and noise using the distortion camera model.

+------------------------------------------------------------------+
|  Global performance comparison of algorithms (click to enlarge)  |
+==================================================================+
|                                                                  |
| .. figure:: static/performance-comparison.png                    |
|    :width: 1680                                                  |
|    :height: 982                                                  |
|    :scale: 50%                                                   |
|    :align: center                                                |
|    :alt: Global performance comparison of algorithms.            |
|                                                                  |
+------------------------------------------------------------------+

The performance is presented in 3 parts: average error on blur parameter,
average error on noise parameter and average runtime for each method.  The seven
methods are (from right to left):

#. **BF** -- brute force search;
#. **SI** -- simplex derivative-free optimizer;
#. **NU** -- NewUOA derivative-free optimizer;
#. **NR** -- Newton-Raphson derivative-based optimizer on patch approximation;
#. **PBF** -- brute force search on patch approximation;
#. **PSI** -- simplex search on patch approximation;
#. **RSI** -- repeated application of PSI method on smaller patches.

.. end of document
