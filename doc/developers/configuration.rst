
.. _autocmake_yml:

Configuring autocmake.yml
=========================

The script ``autocmake.yml`` is the high level place where you configure
your project. Here is an example. We will discuss it in detail further
below::

  name: numgrid

  min_cmake_version: 2.8

  url_root: https://github.com/coderefinery/autocmake/raw/master/

  modules:
  - compilers:
    - source:
      - '%(url_root)modules/fc.cmake'
      - '%(url_root)modules/cc.cmake'
      - '%(url_root)modules/cxx.cmake'
  - flags:
    - source:
      - '%(url_root)compilers/GNU.CXX.cmake'
      - '%(url_root)compilers/Intel.CXX.cmake'
      - 'compilers/Clang.CXX.cmake'
  - plugins:
    - source:
      - '%(url_root)modules/ccache.cmake'
      - 'custom/rpath.cmake'
      - '%(url_root)modules/definitions.cmake'
      - '%(url_root)modules/code_coverage.cmake'
      - '%(url_root)modules/safeguards.cmake'
      - '%(url_root)modules/default_build_paths.cmake'
      - '%(url_root)modules/src.cmake'
      - '%(url_root)modules/googletest.cmake'
      - 'custom/api.cmake'
      - 'custom/test.cmake'


Name and order of sections
--------------------------

First we define the project name (here "numgrid"). This section has to be there
and it has to be called "project" (but it does not have to be on top).

We also have to define ``min_cmake_version``.

The definition ``url_root`` is an interpolation (see :ref:`interpolation`) and
we use it to avoid retyping the same line over and over and to be able to
change it in one place.  The explicit name "url_root" has no special meaning to
Autocmake and we could have chosen a different name.

The section ``modules`` is a list of CMake plugins.  The names of the list
elements (here "compilers", "flags", and "plugins") does not matter to
Autocmake. We could have called them "one", "two", and "whatever", but it would
not make much sense. It is better to choose names that are meaningful to you
and readers of your code.

The order of the elements under ``modules`` does matter and the list will be
processed in the exact order as you specify them in ``autocmake.yml``.


Minimal example
---------------

As a minimal example we take an ``autocmake.yml`` which only contains::

  name: minime
  min_cmake_version: 2.8

If you don't have the ``update.py`` script yet, you need to fetch it from the web::

  $ wget https://github.com/coderefinery/autocmake/raw/master/update.py

First we make sure that the ``update.py`` script is up-to-date and that it has access
to all libraries it needs::

  $ python update.py --self

  - creating .gitignore
  - fetching autocmake/configure.py
  - fetching autocmake/__init__.py
  - fetching autocmake/external/docopt.py
  - fetching autocmake/external/__init__.py
  - fetching autocmake/generate.py
  - fetching autocmake/extract.py
  - fetching autocmake/interpolate.py
  - fetching autocmake/parse_rst.py
  - fetching autocmake/parse_yaml.py
  - fetching update.py

Good. Now we can generate ``CMakeLists.txt`` and the setup script::

  $ python update.py ..

  - parsing autocmake.yml
  - generating CMakeLists.txt
  - generating setup script

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

And we also got a setup script (front-end to ``CMakeLists.txt``) with
the following default options::

  Usage:
    ./setup [options] [<builddir>]
    ./setup (-h | --help)

  Options:
    --type=<TYPE>                          Set the CMake build type (debug, release, or relwithdeb) [default: release].
    --generator=<STRING>                   Set the CMake build system generator [default: Unix Makefiles].
    --show                                 Show CMake command and exit.
    --cmake-executable=<CMAKE_EXECUTABLE>  Set the CMake executable [default: cmake].
    --cmake-options=<STRING>               Define options to CMake [default: ''].
    --prefix=<PATH>                        Set the install path for make install.
    <builddir>                             Build directory.
    -h --help                              Show this screen.

That's not too bad although currently we cannot do much with this since there
are no sources listed, no targets, hence nothing to build. We need to flesh out
``CMakeLists.txt`` by extending ``autocmake.yml`` and this is what we will do
in the next section.


Assembling CMake plugins
------------------------

The preferred way to extend ``CMakeLists.txt`` is by editing ``autocmake.yml``
and using the ``source`` option::

  - compilers:
    - source:
      - '%(url_root)modules/fc.cmake'
      - '%(url_root)modules/cc.cmake'
      - '%(url_root)modules/cxx.cmake'

This will download ``fc.cmake``, ``cc.cmake``, and ``cxx.cmake``, and include
them in ``CMakeLists.txt``, in this order.

You can also include local CMake modules, e.g.::

  - source:
    - 'custom/rpath.cmake'

It is also OK to include several modules at once as we have seen above.  The
modules will be included in the same order as they appear in ``autocmake.yml``.


Fetching files without including them in CMakeLists.txt
-------------------------------------------------------

Sometimes you want to fetch a file without including it in ``CMakeLists.txt``.
This can be done with the ``fetch`` option.  This is for instance done by the
``git_info.cmake`` module (see
https://github.com/coderefinery/autocmake/blob/master/modules/git_info/git_info.cmake#L10-L13).

If ``fetch`` is invoked in ``autocmake.yml``, then the fetched file is placed
under ``downloaded/``.  If ``fetch`` is invoked from within a CMake module
documentation (see below), then the fetched file is placed into the same
directory as the CMake module file which fetches it.


Generating setup options
------------------------

Options for the setup script can be generated with the ``docopt``
option. As an example, the following ``autocmake.yml`` snippet will add a
``--something`` flag::

  - my_section:
    - docopt: "--something Enable something [default: False]."


Setting CMake options
---------------------

Configure-time CMake options can be generated with the ``define`` option.
Consider the following example which toggles the CMake variable
``ENABLE_SOMETHING``::

  - my_section:
    - docopt: "--something Enable something [default: False]."
    - define: "'-DENABLE_SOMETHING={0}'.format(arguments['--enable-something'])"


Setting environment variables
-----------------------------

You can export environment variables at configure-time using the ``export``
option. Consider the following example::

  docopt:
    - "--cc=<CC> C compiler [default: gcc]."
    - "--extra-cc-flags=<EXTRA_CFLAGS> Extra C compiler flags [default: '']."
  export: "'CC={0}'.format(arguments['--cc'])"
  define: "'-DEXTRA_CFLAGS=\"{0}\"'.format(arguments['--extra-cc-flags'])"


Auto-generating configurations from the documentation
-----------------------------------------------------

To avoid a boring re-typing of boilerplate ``autocmake.yml`` code it is possible
to auto-generate configurations from the documentation. This is the case
for many core modules which come with own options once you have sourced them.

The lines following ``# autocmake.yml configuration::`` are
understood by the ``update.py`` script to infer ``autocmake.yml`` code from the
documentation. As an example consider
https://github.com/coderefinery/autocmake/blob/master/modules/cc.cmake#L20-L26.
Here, ``update.py`` will infer the configurations for ``docopt``, ``export``,
and ``define``.
