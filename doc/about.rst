

About Autocmake
===============

CMake typically generates Makefiles based on CMakeLists.txt files.  Autocmake
assembles CMake modules, generates ``CMakeLists.txt`` as well as ``setup.py``,
which serves as a front-end to ``CMakeLists.txt``. All this is done based on a
lightweight ``autocmake.cfg`` file.


CMake cons
----------

- More complexity (not because CMake is complex but because of another layer)
- Yet another thing to learn: requires learning and training
- Typically many files instead of one file
- Documentation ("Which file do I need to edit to achieve X?")


CMake pros
----------

- Makes it possible and relatively easy to download, configure, build, install, and link external modules
- Cross-platform system- and library-discovery
- CTest uses a Makefile (possible to run tests with -jN)


Motivation to create a CMake framework library
----------------------------------------------

- Simplify CMake code transfer (scientific projects typically have very similar requirements)
    - FC, CC, CXX
    - Compiler flags
    - Front-end script (setup.py)
    - MPI, OMP, CUDA
    - Math libraries
- Make it easy for people who know CMake well to create well defined configurations
- Make it easy for people who do not know CMake to generate a CMake infrastructure within minutes
- Philosophy
    - Explicit is better than implicit
    - Convention over configuration
- Well documented set of plug-ins
