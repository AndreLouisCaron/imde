.. imde/docs/getting-started.rst
   Copyright 2011, Université de Sherbrooke

===============
Getting Started
===============

Don't worry, you won't need to install anything!

Getting the source code
-----------------------

.. note::

   The project source code has been *significantly* re-architectured and
   simplified after the cited papers have been produced.  Most of the source
   code history only covers the re-write and not the original project's
   development.  Any bugs in the code should be considered to have been
   re-written since the papers were published.

The source code for this software is hosted on `GitHub`_.  Check out the `imde
project repository`_ to view the history and browse the source code.

To check out a local copy of the source code, fire up a shell and type:

.. code-block:: bash

   git clone git://github.com/AndreLouisCaron/imde.git
   git submodule init
   git submodule update

If you don't have `git`_ installed, you can download the latest source code in
a tarball or zip file directly from GitHub at:

    https://github.com/AndreLouisCaron/imde/archives/master

Testing the Code
----------------

Open MATLAB, then change the working directory to the root of the source code:

.. code-block:: matlab

     % move to project root folder.
   cd('path/to/imde');
   
     % make sure 'imde' functions can be found.
   addpath('./code/');

Finally, try running the code in the basic estimation session.  See
:ref:`basic-session`.

Using NewUOA
------------

To use the :mat:fn:`newuoa` estimation method, you will need to build the NewUOA
MATLAB extension using the MEX compiler (built-in to MATLAB).  See
:ref:`newuoa`.

.. _`GitHub`: https://github.com/
.. _`imde project repository`: https://github.com/AndreLouisCaron/imde
.. _`git`: http://git-scm.com/
