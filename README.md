[![Build Status](https://travis-ci.org/scisoft/autocmake.svg?branch=master)](https://travis-ci.org/scisoft/autocmake/builds)


# Autocmake

A CMake plugin composer.
Licensed under [BSD-3](../master/LICENSE).


## Projects using Autocmake

- [Numgrid](https://github.com/bast/numgrid/)
- [DIRAC](http://diracprogram.org)


## Bootstrapping a new project

Download the ``bootstrap.py`` and execute it to fetch other infrastructure files
which will be needed to build the project:

    mkdir cmake  # does not have to be called "cmake" - take the name you prefer
    cd cmake
    wget https://github.com/scisoft/autocmake/raw/master/bootstrap.py
    python bootstrap.py --update

This creates (or updates) the following files (an existing ``autocmake.cfg`` is
not overwritten by the script):

    cmake/
    ├── bootstrap.py   # no need to edit
    ├── autocmake.cfg  # edit this file
    └── lib/
        ├── config.py  # no need to edit
        └── docopt.py  # no need to edit

If you use version control, then now is a good moment to status/diff/add
the newly created files.


## Creating the CMake infrastructure

Then edit ``autocmake.cfg`` and run the ``bootstrap.py`` script which
creates ``CMakeLists.txt`` and ``setup.py`` in the build path:

    python bootstrap.py ..

The script also copies or downloads CMake modules specified in ``autocmake.cfg`` to a directory
called ``modules/``:

    cmake/
    ├── bootstrap.py
    ├── autocmake.cfg
    └── lib/
        ├── config.py
        └── docopt.py
        └── modules/   # CMakeLists.txt includes CMake modules from this directory

Now you have ``CMakeLists.txt`` and ``setup.py`` in the project root and you can build
the project:

    cd ..
    python setup.py [-h]
    cd build
    make


## Customizing the CMake modules

The CMake modules can be customized directly inside ``modules/`` but this is
not very convenient as the customizations may be overwritten by the
``boostrap.py`` script.

A better solution is to download the CMake modules that you wish you customize
to a separate directory and source the customized CMake modules in
``autocmake.cfg``.
