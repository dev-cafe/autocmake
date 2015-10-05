

FAQ for users
=============


TL;DR How do I compile the code?
--------------------------------

::

  $ python setup.py [-h]
  $ cd build
  $ make


How can I specify the compiler?
-------------------------------

By default ``setup.py`` will attempt GNU compilers.
You can specify compilers manually like this::

  $ python setup.py --fc=ifort --cc=icc --cxx=icpc


How can I add compiler flags?
-----------------------------

You can do this with ``--extra-fc-flags``, ``--extra-cc-flags``, or
``--extra-cxx-flags`` (depending on the set of enabled languages)::

  $ python setup.py --fc=gfortran --extra-fc-flags='-some-exotic-flag'


How can I redefine compiler flags?
----------------------------------

If you export compiler flags using the environment variables ``FCFLAGS``,
``CFLAGS``, or ``CXXFLAGS``, respectively, then the configuration will use
those flags and neither augment them, nor redefine them. Setting
these environment variables you have full control over the flags
without editing CMake files.


How can I select CMake options via the setup.py script?
-------------------------------------------------------

Like this::

  $ python setup.py --cmake-options="-DTHIS_OPTION=ON -DTHAT_OPTION=OFF"
