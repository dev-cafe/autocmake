
.. _autocmake_cfg:

Configuring autocmake.cfg
=========================

The script ``autocmake.cfg`` is the high level place where you configure
your project. Here is an example. We will discuss it in detail further
below::

  [project]
  name: numgrid

  [fc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc_optional.cmake

  [cc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cc.cmake

  [cxx]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cxx.cmake

  [flags]
  source: https://github.com/scisoft/autocmake/raw/master/compilers/GNU.CXX.cmake
          https://github.com/scisoft/autocmake/raw/master/compilers/Intel.CXX.cmake

  [coverage]
  source: https://github.com/scisoft/autocmake/raw/master/modules/code_coverage.cmake

  [safeguards]
  source: https://github.com/scisoft/autocmake/raw/master/modules/safeguards.cmake

  [default_build_paths]
  source: https://github.com/scisoft/autocmake/raw/master/modules/default_build_paths.cmake

  [src]
  source: https://github.com/scisoft/autocmake/raw/master/modules/src.cmake

  [googletest]
  source: https://github.com/scisoft/autocmake/raw/master/modules/googletest.cmake

  [custom]
  source: custom/api.cmake
          custom/test.cmake


Name and order of sections
--------------------------

We see that the configuration file has sections.
The only section where the name matters is ``[project]``::

  [project]
  name: numgrid

This is where we define the project name (here "numgrid"). Every project needs
at least this section and this section has to be called "project".

The names of the other sections do not matter to Autocmake. You can name them like this::

  [project]
  name: numgrid

  [one]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc_optional.cmake

  [two]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cc.cmake

  [whatever]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cxx.cmake

But it is much better to choose names that are meaningful to you.

The order of the sections does matter and the sections will be processed in the
exact order as you specify them in ``autocmake.cfg``.


Assembling CMake plugins
------------------------

Write me ...


Fetching files without including them in CMakeLists.txt
-------------------------------------------------------

Write me ...


Generating setup.py options
---------------------------

Write me ...


Setting environment variables
-----------------------------

Write me ...


Auto-generating configurations from the documentation
-----------------------------------------------------

Write me ...


Overriding documented configurations
------------------------------------

Write me ...
