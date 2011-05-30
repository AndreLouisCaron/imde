.. imde -- Image Multi-Distortion Estimation
   Copyright 2011, Université de Sherbrooke

=================================
Image Multi-Distortion Estimation
=================================

The Image Multi-Distortion Estimation project is issued from a partnership
between l'`Université de Sherbrooke`_ and l'`Université de Caen`_.

Key people in the project:

#. `André Caron`_, M.Sc. Student at l'Université de Sherbrooke;
#. `Pierre-Marc Jodoin`_, Associate Professor at l'Université de Sherbrooke;
#. `Christophe Charrier`_, Maître de Conférences at l'Université de Caen.

Contents
========

.. toctree::
   :maxdepth: 2

   docs/introduction.rst
   docs/getting-started.rst
   docs/3rd-party.rst
   code/index.rst

Publications
============

This project has lead to two international publications:

#. **André Caron, Pierre-Marc Jodoin and Christophe Charrier**, "Image
   Multi-Distortion Estimation", *in Proceedings of IEEE Computer Society
   International Conference on Pattern Recognition (ICPR)*, 2010, Oral
   Presentation -- `ICPR 2010`_ had a 18% acceptance rate on oral presentations

       In this paper, we present a method for estimating the amount of Gaussian
       noise and Gaussian blur in a distorted image. Our method is based on the
       MS-SSIM framework which, although designed to measure image quality, is
       used to estimate the amount of blur and noise in a degraded image given a
       reference image. Various search strategies such as Newton, Simplex, and
       brute force search are presented and rigorously compared. Based on
       quantitative results, we show that the amount of blur and noise in a
       distorted image can be recovered with an accuracy up to 0.95% and 5.40%,
       respectively. To our knowledge, such precision has never been achieved
       before.

   `Read the full paper <_static/ICPR2010.pdf>`_.

#. **André Caron and Pierre-Marc Jodoin**, "Image Multi-Distortion Estimation",
   accepted at *IEEE Computer Society Transactions on Image Processing (TIP)*,
   -- `IEEE TIP`_ has a 2.848 impact factor

       We present a method for estimating the amount of noise and blur in a
       distorted image.  Our method is based on the MS-SSIM framework which,
       although designed to measure image quality, is used to estimate the
       amount of blur and noise in a degraded image given a reference image.  We
       show that there exists a bijective mapping between the 2D noise/blur
       space and the 3D MS-SSIM space which allows to recover distortion
       parameters.  That mapping allows to formulate the multi-distortion
       estimation problem as a classical optimization problem.  Various search
       strategies such as Newton, Simplex, NewUOA, and brute force search are
       presented and rigorously compared.  We also show that a bicubic patch can
       be used to approximate the bijective mapping between the noise/blur space
       and the 3D MS-SSIM space.  Interestingly, the use of such a patch reduces
       the processing time by a factor of 40 without significantly reducing
       precision.  Based on quantitative results, we show that the amount of
       different types of blur and noise in a distorted image can be recovered
       with an accuracy of roughly 2% and 8%, respectively.  Our methods
       are compared to four state-of-the-art noise and blur estimation
       techniques.

   `Read the full paper <_static/TIP2011.pdf>`_.

.. end of document

.. _`Université de Sherbrooke`: http://www.usherbrooke.ca/
.. _`Université de Caen`: http://www.unicaen.fr/
.. _`André Caron`: http://pages.usherbrooke.ca/acaron/
.. _`Pierre-Marc Jodoin`: http://www.dmi.usherb.ca/~jodoin/en/
.. _`Christophe Charrier`: http://greyc.stlo.unicaen.fr/charrier/
.. _`IEEE TIP`: http://www.signalprocessingsociety.org/publications/periodicals/image-processing/
.. _`ICPR 2010`: http://www.icpr2010.org/
