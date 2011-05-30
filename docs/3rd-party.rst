.. imde/docs/newuoa.rst
   Copyright 2011, Université de Sherbrooke

==================
3rd-party Software
==================

This project includes a small amount of software written by other parties.  This
source code is release, to the best of the authors' knowledge, in compliance
with the respective projects' software licenses.

.. _newuoa:

NewUOA
------

The NewUOA software for unconstrained optimization without derivatives
[Powell2006]_ is a modern development in optimization methods.  It conveniently
replaces the `simplex algorithm`_ as it has similar requirements, but --
apparently -- has much better performance with tougher objective functions.

The implementation used in this project is the one distributed by Guilbert
Mathieu in the `Scilab-NewUOA interface`_.  It was slightly modified, mainly to
remove some by-products of `f2c`_ and Scilab-specific printing functions.

The code was originally written in Fortran 77, then converted to C using `f2c`.
A C++ wrapper was written to integrate the code with MATLAB.  To use the NewUOA
optimizer, build the MATLAB Extension directly from MATLAB using the `mex`_
function.  Make sure your current directory is in the `imde/code` and type the
following at the MATLAB prompt:

.. code-block:: matlab

   mex('mnewuoa.cpp', 'newuoa.c', 'newuob.c', ...
       'bigden.c', 'biglag.c', 'trsapp.c', 'update.c');

If this doesn't work, make sure you get familiar with MEX files.  The MathWorks
product support has a `MEX-files Guide`_ to help answer basic questions.

License and Copyright
~~~~~~~~~~~~~~~~~~~~~

The NewUOA code is:

   'NEWUOA Scilab Interface' (interface with scilab of the NEWUOA Library)
   The 'NEWUOA Library' is an unconstrainted optimization algorithm without
   derivtatives What is Licensed is the Scilab Interface and not the NEWUOA
   Library written by MJD Powell
   Copyright (C) 2005 GUILBERT

and licensed under the `GNU Library General Public License 2.1`_.

The author considers its MATLAB binding ``imde/code/mnewuoa.cpp`` as a
derivative work.  This binding is

   | Copyrright André Caron, 2009-2011

and also licensed under the `GNU Library General Public License 2.1`_.

All other code (MATLAB M-files and C++ ``mex`` library found under
``imde/code/mex/``) is

   | Copyrright André Caron, 2009-2011

and released under the `Artistic License 2.0`_.

.. note::

   The start of each source file should be identified with comments indicating
   which license applies to the given code.

References
~~~~~~~~~~

.. [Powell2006] **M. Powell**, "The NewUOA software for unconstrained
                optimization without derivatives", *Nonconvex Optimization and
		Its Applications*, 2006

.. _`simplex algorithm`: http://en.wikipedia.org/wiki/Simplex_algorithm
.. _`Scilab-NewUOA interface`: http://www.inrialpes.fr/bipop/people/guilbert/newuoa/newuoa.html
.. _`f2c`: http://www.netlib.org/f2c/
.. _`mex`: http://www.mathworks.com/help/techdoc/ref/mex.html
.. _`MEX-files Guide`: http://www.mathworks.com/support/tech-notes/1600/1605.html
.. _`GNU Library General Public License 2.1`: http://www.opensource.org/licenses/lgpl-2.1
.. _`Artistic License 2.0`: http://www.opensource.org/licenses/Artistic-2.0
