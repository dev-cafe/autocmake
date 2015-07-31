
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

This is where we define the project name (here "numgrid"). This section has to
be there and it has to be called "project" (but it does not have to be on top).

The names of the other sections do not matter to Autocmake. You could name them like this::

  [project]
  name: numgrid

  [one]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc_optional.cmake

  [two]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cc.cmake

  [whatever]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cxx.cmake

But it would not make much sense. It is better to choose names that are
meaningful to you.

The order of the sections does matter and the sections will be processed in the
exact order as you specify them in ``autocmake.cfg``.


Minimal example
---------------

As a minimal example we take an ``autocmake.cfg`` which only contains::

  [project]
  name: minime

First we make sure that the ``update.py`` script is up-to-date and that it has access
to all libraries it needs::

  $ python update.py --self

  - fetching lib/config.py
  - fetching lib/docopt.py
  - fetching update.py

Good. Now we can generate ``CMakeLists.txt`` and ``setup.py``::

  $ python update ..

  - parsing autocmake.cfg
  - generating CMakeLists.txt
  - generating setup.py

Excellent. Here is the generated ``CMakeLists.txt``::

  # set minimum cmake version
  cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

  # project name
  project(minime)

  # do not rebuild if rules (compiler flags) change
  set(CMAKE_SKIP_RULE_DEPENDENCY TRUE)

  # if CMAKE_BUILD_TYPE undefined, we set it to Debug
  if(NOT CMAKE_BUILD_TYPE)
      set(CMAKE_BUILD_TYPE "Debug")
  endif()

This is the very bare minimum. Every Autocmake project will have at least these
settings.

And we also got a ``setup.py`` script (front-end to ``CMakeLists.txt``) with
the following default options::

  $ python setup.py -h

  Usage:
    ./setup.py [options] [<builddir>]
    ./setup.py (-h | --help)

  Options:
    --type=<TYPE>              Set the CMake build type (debug, release, or relwithdeb) [default: release].
    --generator=<STRING>       Set the CMake build system generator [default: Unix Makefiles].
    --show                     Show CMake command and exit.
    --cmake-options=<OPTIONS>  Define options to CMake [default: None].
    <builddir>                 Build directory.
    -h --help                  Show this screen.

That's not too bad although currently we cannot do much with this since there
are no sources listed, no targets, hence nothing to build. We need to flesh out
``CMakeLists.txt`` and this is what we will do in the next section.


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
