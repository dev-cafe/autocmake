
.. _autocmake_cfg:

Configuring autocmake.cfg
=========================

The script ``autocmake.cfg`` is the high level place where you configure
your project. Here is an example. We will discuss it in detail further
below::

  [project]
  name: numgrid
  min_cmake_version: 2.8

  [fc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc.cmake

  [cc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cc.cmake

  [cxx]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cxx.cmake

  [flags]
  source: https://github.com/scisoft/autocmake/raw/master/compilers/GNU.CXX.cmake
          https://github.com/scisoft/autocmake/raw/master/compilers/Intel.CXX.cmake

  [rpath]
  source: custom/rpath.cmake

  [definitions]
  source: https://github.com/scisoft/autocmake/raw/master/modules/definitions.cmake

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
  min_cmake_version: 2.8

This is where we define the project name (here "numgrid"). This section has to
be there and it has to be called "project" (but it does not have to be on top).

The names of the other sections do not matter to Autocmake. You could name them like this::

  [project]
  name: numgrid
  min_cmake_version: 2.8

  [one]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc.cmake

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
  min_cmake_version: 2.8

First we make sure that the ``update.py`` script is up-to-date and that it has access
to all libraries it needs::

  $ python update.py --self

  - creating .gitignore
  - fetching lib/config.py
  - fetching lib/docopt/docopt.py
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

  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake/downloaded)

This is the very bare minimum. Every Autocmake project will have at least these
settings.

And we also got a ``setup.py`` script (front-end to ``CMakeLists.txt``) with
the following default options::

  Usage:
    ./setup.py [options] [<builddir>]
    ./setup.py (-h | --help)

  Options:
    --type=<TYPE>                          Set the CMake build type (debug, release, or relwithdeb) [default: release].
    --generator=<STRING>                   Set the CMake build system generator [default: Unix Makefiles].
    --show                                 Show CMake command and exit.
    --cmake-executable=<CMAKE_EXECUTABLE>  Set the CMake executable [default: cmake].
    --cmake-options=<STRING>               Define options to CMake [default: ''].
    <builddir>                             Build directory.
    -h --help                              Show this screen.

That's not too bad although currently we cannot do much with this since there
are no sources listed, no targets, hence nothing to build. We need to flesh out
``CMakeLists.txt`` by extending ``autocmake.cfg``
and this is what we will do in the next section.


Assembling CMake plugins
------------------------

The preferred way to extend ``CMakeLists.txt`` is by editing ``autocmake.cfg``
and using the ``source`` option::

  [fc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc.cmake

This will download ``fc.cmake`` and include it in ``CMakeLists.txt``.

You can also include local CMake modules, e.g.::

  [rpath]
  source: custom/rpath.cmake

It is also OK to include several modules at once::

  [flags]
  source: https://github.com/scisoft/autocmake/raw/master/compilers/GNU.CXX.cmake
          https://github.com/scisoft/autocmake/raw/master/compilers/Intel.CXX.cmake

The modules will be included in the same order as they appear in ``autocmake.cfg``.


Fetching files without including them in CMakeLists.txt
-------------------------------------------------------

Sometimes you want to fetch a file without including it in ``CMakeLists.txt``.
This can be done with the ``fetch`` option.  This is for instance done by the
``git_info.cmake`` module (see
https://github.com/scisoft/autocmake/blob/master/modules/git_info/git_info.cmake#L10-L11).

If ``fetch`` is invoked in ``autocmake.cfg``, then the fetched file is placed
under ``downloaded/``.  If ``fetch`` is invoked from within a CMake module
documentation (see below), then the fetched file is placed into the same
directory as the CMake module file which fetches it.


Generating setup.py options
---------------------------

Options for the ``setup.py`` script can be generated with the ``docopt``
option. As an example, the following ``autocmake.cfg`` snippet will add a
``--something`` flag::

  [my_section]
  docopt: --something Enable something [default: False].


Setting CMake options
---------------------

Configure-time CMake options can be generated with the ``define`` option.
Consider the following example which toggles the CMake variable
``ENABLE_SOMETHING``::

  [my_section]
  docopt: --something Enable something [default: False].
  define: '-DENABLE_SOMETHING={0}'.format(arguments['--something'])


Setting environment variables
-----------------------------

You can export environment variables at configure-time using the ``export``
option. Consider the following example::

  [cc]
  docopt: --cc=<CC> C compiler [default: gcc].
          --extra-cc-flags=<EXTRA_CFLAGS> Extra C compiler flags [default: ''].
  export: 'CC=%s' % arguments['--cc']
  define: '-DEXTRA_CFLAGS="%s"' % arguments['--extra-cc-flags']


Auto-generating configurations from the documentation
-----------------------------------------------------

To avoid a boring re-typing of boilerplate ``autocmake.cfg`` code it is possible
to auto-generate configurations from the documentation. This is the case
for many core modules which come with own options once you have sourced them.

The lines following ``# autocmake.cfg configuration::`` are
understood by the ``update.py`` script to infer ``autocmake.cfg`` code from the
documentation. As an example consider
https://github.com/scisoft/autocmake/blob/master/modules/cc.cmake#L20-L25.
Here, ``update.py`` will infer the configurations for ``docopt``, ``export``,
and ``define``.


Overriding documented configurations
------------------------------------

Configurable documented defaults can be achieved using interpolations.  See for
instance
https://github.com/scisoft/autocmake/blob/master/modules/boost/boost.cmake#L33-L36.
These can be modified within ``autocmake.cfg`` with a dictionary, e.g.:
https://github.com/scisoft/autocmake/blob/master/test/boost_libs/cmake/autocmake.cfg#L9
