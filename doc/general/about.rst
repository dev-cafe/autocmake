

About Autocmake
===============

Building libraries and executables from sources can be a complex task. Several
solutions exist to this problem: GNU Makefiles is the traditional approach.
Today, CMake is one of the trendier alternatives. Autocmake is a script which
composes well tested CMake building blocks into a CMake project and generates
``CMakeLists.txt`` as well as ``setup.py``, which serves as a front-end to
``CMakeLists.txt``. All this is done based on a lightweight ``autocmake.cfg``
file::

  python update.py --self
       |                                   |
       | fetches Autocmake                 |
       | infrastructure                    |
       v                           Developer maintaining
  autocmake.cfg                        Autocmake
       |                                   |
       | python update.py ..               |
       |                                   |
       v                                   v
  CMakeLists.txt (and setup.py front-end)
       |                                   |
       | python setup.py                   |
       | which invokes CMake               |
       v                             User of the code
  Makefile (or something else)             |
       |                                   |
       | make                              |
       |                                   |
       v                                   v
  Build/install/test targets


Why Autocmake
-------------

The main motivation for us to create Autocmake as a CMake framework library and
CMake module composer was to simplify CMake code transfer between codes. We got
tired of manually diffing and copy-pasting boiler-plate CMake code and watching
it diverge while maintaining the CMake infrastructure in a growing number of
scientific projects which typically have very similar requirements:

- Fortran and/or C and/or C++ support
- Tuning of compiler flags
- Front-end script for the CMake-unaware user (setup.py)
- Support for parallelization: MPI, OMP, CUDA
- Math libraries: BLAS, LAPACK

Our other motivation for Autocmake was to make it easier for developers who do
not know CMake to use CMake by providing a higher-level entry point to CMake.

Autocmake is a chance to provide a well documented and tested set of CMake
plug-ins. With this we wish to give also users of codes the opportunity to
introduce the occasional tweak without the need to dive deep into CMake
documentation.


Explicit is better than implicit
--------------------------------

Our design principle is to let Autocmake do one thing, as explicitly as
possible and to minimize "hidden" actions in the background.


Convention over configuration
-----------------------------

Our guideline is to follow good established conventions in order to allow users
and developers to recognize the configuration when experimenting with an
Autocmake-powered project.
