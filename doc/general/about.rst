

About Autocmake
===============

Building libraries and executables from sources can be a complex task. Several
solutions exist to this problem: GNU Makefiles is the traditional approach.
Today, CMake is one of the trendier alternatives which can generate Makefiles
starting from a file called ``CMakeLists.txt``.

Autocmake composes CMake building blocks into a CMake project and generates
``CMakeLists.txt`` as well as a setup script, which serves as a front-end to
``CMakeLists.txt``. All this is done based on a lightweight ``autocmake.yml``
file::

  python update.py --self
       |                                   |
       | fetches Autocmake                 |
       | infrastructure                    |
       | and updates the update.py script  |
       |                                   |
       v                           Developer maintaining
  autocmake.yml                        Autocmake
       |                                   |
       | python update.py ..               |
       |                                   |
       v                                   v
  CMakeLists.txt (and setup front-end)
       |                                   |
       | python setup or ./setup           |
       | which invokes CMake               |
       v                             User of the code
  Makefile (or something else)             |
       |                                   |
       | make                              |
       |                                   |
       v                                   v
  Build/install/test targets

Our main motivation to create Autocmake as a CMake framework library and
CMake module composer is to simplify CMake code transfer between codes. We got
tired of manually diffing and copy-pasting boiler-plate CMake code and watching
it diverge while maintaining the CMake infrastructure in a growing number of
scientific projects which typically have very similar requirements:

- Fortran and/or C and/or C++ support
- Tuning of compiler flags
- Front-end script with good defaults
- Support for parallelization: MPI, OMP, CUDA
- Math libraries: BLAS, LAPACK

Our other motivation for Autocmake was to make it easier for developers who do
not know CMake to provide a higher-level entry point to CMake.

Autocmake is a chance to provide a well documented and tested set of CMake
plug-ins. With this we wish to give also users of codes the opportunity to
introduce the occasional tweak without the need to dive deep into CMake
documentation.
