

Building a new project
======================


Bootstrapping Autocmake
-----------------------

Download the ``update.py`` and execute it to fetch other infrastructure files
which will be needed to build the project. Example on Linux::

  mkdir cmake  # does not have to be called "cmake" - take the name you prefer
  cd cmake
  wget https://github.com/scisoft/autocmake/raw/master/update.py
  python update.py --self

Example on Windows using tools installed with Git::

  mkdir cmake  # does not have to be called "cmake" - take the name you prefer
  cd cmake
  C:\Program Files (x86)\Git\bin\curl.exe -o update.py -L https://github.com/scisoft/autocmake/raw/master/update.py
  python update.py --self

Do not add ``...Git\bin...`` to PATH. Otherwise you will experience conflicts with CMake.

This creates (or updates) the following files (an existing ``autocmake.cfg`` is
not overwritten by the script)::

  cmake/
      update.py      # no need to edit
      autocmake.cfg  # edit this file
      lib/
          config.py  # no need to edit
          docopt.py  # no need to edit

Note that all other listed files are overwritten (use version control!).


Generating the CMake infrastructure
-----------------------------------

Edit ``autocmake.cfg`` and then run the ``update.py`` script which
creates ``CMakeLists.txt`` and ``setup.py`` in the build path::

  python update.py ..

The script also copies or downloads CMake modules specified in ``autocmake.cfg`` to a directory
called ``modules/``::

  cmake/
      update.py
      autocmake.cfg
      lib/
          config.py
          docopt.py
          modules/   # CMakeLists.txt includes CMake modules from this directory


Building the project
--------------------

Now you have ``CMakeLists.txt`` and ``setup.py`` in the project root and you can build
the project::

  cd ..
  python setup.py [-h]
  cd build
  make # or mingw32-make on Windows
