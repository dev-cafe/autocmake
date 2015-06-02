

About Autocmake
===============

You typically want to use CMake when you get tired of manually editing
Makefiles. Autocmake is for people who are tired of editing CMake files.
Autocmake assembles CMake modules, generates ``CMakeLists.txt`` as well as
``setup.py``, which serves as a front-end to ``CMakeLists.txt``. All this is
done based on a lightweight ``autocmake.cfg`` file::

  autocmake.cfg
       |
       | Autocmake
       v
  CMakeLists.txt (and setup.py front-end)
       |
       | setup.py (which invokes CMake)
       v
  Makefile (or something else)
       |
       | make
       v
  Build/install/test targets


Why Autocmake
-------------

The main motivation for us to create Autocmake as a CMake framework library was
to simplify CMake code transfer between codes. We got tired of manually diffing
and and copy-pasting boiler-plate CMake code and watching it diverge while
maintaining the CMake infrastructure in a growing number of scientific projects
which typically have very similar requirements:

- Fortran and/or C and/or C++ support
- Compiler flags
- Front-end script (setup.py)
- Support for parallelization: MPI, OMP, CUDA
- Math libraries (BLAS, LAPACK)

Our other motivation for Autocmake was to make it easier for developers who do
not know CMake to generate a CMake infrastructure within minutes.

Autocmake is a chance to provide well documented and tested set of CMake
plug-ins. With this we want to give also users of codes which use Autocmake the
opportunity to introduce the occasional tweak without the need to read lengthy
manuals.

We try to follow two design principles:

- Explicit is better than implicit
- Convention over configuration
