

Generating the CMake infrastructure
===================================

Edit ``autocmake.cfg`` and run the ``bootstrap.py`` script which
creates ``CMakeLists.txt`` and ``setup.py`` in the build path::

  python bootstrap.py ..

The script also copies or downloads CMake modules specified in ``autocmake.cfg`` to a directory
called ``modules/``::

  cmake/
      bootstrap.py
      autocmake.cfg
      lib/
          config.py
          docopt.py
          modules/   # CMakeLists.txt includes CMake modules from this directory

Now you have ``CMakeLists.txt`` and ``setup.py`` in the project root and you can build
the project::

  cd ..
  python setup.py [-h]
  cd build
  make
