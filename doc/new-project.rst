

Building a new project
======================


Bootstrapping Autocmake
-----------------------

Download the ``update.py`` and execute it to fetch other infrastructure files
which will be needed to build the project (on Windows ``wget`` is probably
not available - in this case use an alternative)::

  mkdir cmake  # does not have to be called "cmake" - take the name you prefer
  cd cmake
  wget https://github.com/scisoft/autocmake/raw/master/update.py
  python update.py --self

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

The script also downloads remote CMake modules specified in ``autocmake.cfg`` to a directory
called ``downloaded/``::

  cmake/
      update.py
      autocmake.cfg
      lib/
          config.py
          docopt.py
          downloaded/  # contains CMake modules fetched from the web


Building the project
--------------------

Now you have ``CMakeLists.txt`` and ``setup.py`` in the project root and you can build
the project::

  cd ..
  python setup.py [-h]
  cd build
  make
