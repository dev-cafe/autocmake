

Example Hello World project
===========================

This is a brief example for the busy and impatient programmer. For a longer
tour please see :ref:`autocmake_cfg`.

We start with a mixed Fortran-C project with the following sources::

  feature1.F90
  feature2.c
  main.F90

First thing we do is to create a directory ``src/`` and we move all sources
there. This is not necessary for Autocmake but it is a generally good practice::

  .
  `-- src
      |-- feature1.F90
      |-- feature2.c
      `-- main.F90

Now we create ``cmake/`` and fetch ``update.py``::

  $ mkdir cmake
  $ cd cmake/
  $ wget https://raw.githubusercontent.com/scisoft/autocmake/master/update.py
  $ python update.py --self

Now from top-level our file tree looks like this::

  .
  |-- cmake
  |   |-- autocmake.cfg
  |   |-- lib
  |   |   |-- config.py
  |   |   `-- docopt.py
  |   `-- update.py
  `-- src
      |-- feature1.F90
      |-- feature2.c
      `-- main.F90

Now we edit ``cmake/autocmake.cfg`` to look like this::

  [project]
  name: hello

  [fc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/fc.cmake

  [cc]
  source: https://github.com/scisoft/autocmake/raw/master/modules/cc.cmake

  [src]
  source: https://github.com/scisoft/autocmake/raw/master/modules/src.cmake

What we have specified here is the project name and that we wish Fortran and C
support. The ``[src]`` module tells CMake to include a ``src/CMakeLists.txt``.
We need to create ``src/CMakeLists.txt`` which can look like this::

  add_executable(
      hello.x
      main.F90
      feature1.F90
      feature2.c
      )

We wrote that we want to get an executable "hello.x" built from our sources.

Now we have everything to generate ``CMakeLists.txt`` and ``setup.py``::

  $ cd cmake
  $ python update ..

And this is what we got::

  .
  |-- CMakeLists.txt
  |-- cmake
  |   |-- autocmake.cfg
  |   |-- downloaded
  |   |   |-- autocmake_cc.cmake
  |   |   |-- autocmake_fc_optional.cmake
  |   |   `-- autocmake_src.cmake
  |   |-- lib
  |   |   |-- config.py
  |   |   `-- docopt.py
  |   `-- update.py
  |-- setup.py
  `-- src
      |-- CMakeLists.txt
      |-- feature1.F90
      |-- feature2.c
      `-- main.F90

Now we are ready to build::

  $ python setup.py --fc=gfortran --cc=gcc

  FC=gfortran CC=gcc cmake -DEXTRA_FCFLAGS="''" -DENABLE_FC_SUPPORT="ON" -DEXTRA_CFLAGS="''" -DCMAKE_BUILD_TYPE=release -G "Unix Makefiles" None /home/user/example

  -- The C compiler identification is GNU 4.9.2
  -- The CXX compiler identification is GNU 4.9.2
  -- Check for working C compiler: /usr/bin/gcc
  -- Check for working C compiler: /usr/bin/gcc -- works
  -- Detecting C compiler ABI info
  -- Detecting C compiler ABI info - done
  -- Detecting C compile features
  -- Detecting C compile features - done
  -- Check for working CXX compiler: /usr/bin/c++
  -- Check for working CXX compiler: /usr/bin/c++ -- works
  -- Detecting CXX compiler ABI info
  -- Detecting CXX compiler ABI info - done
  -- Detecting CXX compile features
  -- Detecting CXX compile features - done
  -- The Fortran compiler identification is GNU 4.9.2
  -- Check for working Fortran compiler: /usr/bin/gfortran
  -- Check for working Fortran compiler: /usr/bin/gfortran  -- works
  -- Detecting Fortran compiler ABI info
  -- Detecting Fortran compiler ABI info - done
  -- Checking whether /usr/bin/gfortran supports Fortran 90
  -- Checking whether /usr/bin/gfortran supports Fortran 90 -- yes
  -- Configuring done
  -- Generating done
  -- Build files have been written to: /home/user/example/build

     configure step is done
     now you need to compile the sources:
     $ cd build
     $ make

  $ cd build/
  $ make

  Scanning dependencies of target hello.x
  [ 25%] Building Fortran object src/CMakeFiles/hello.x.dir/main.F90.o
  [ 50%] Building Fortran object src/CMakeFiles/hello.x.dir/feature1.F90.o
  [ 75%] Building C object src/CMakeFiles/hello.x.dir/feature2.c.o
  [100%] Linking Fortran executable hello.x
  [100%] Built target hello.x

Excellent! All that could have been done with few command lines directly but
now we have a cross-platform project and can extend it and customize it and we
got a front-end script and command-line parser for free.  Now go out and
explore more Autocmake modules and features.
