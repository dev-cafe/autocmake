

Bootstrapping a new project
===========================

Download the ``bootstrap.py`` and execute it to fetch other infrastructure files
which will be needed to build the project::

  mkdir cmake  # does not have to be called "cmake" - take the name you prefer
  cd cmake
  wget https://github.com/scisoft/autocmake/raw/master/bootstrap.py
  python bootstrap.py --update

This creates (or updates) the following files (an existing ``autocmake.cfg`` is
not overwritten by the script)::

  cmake/
      bootstrap.py   # no need to edit
      autocmake.cfg  # edit this file
      lib/
          config.py  # no need to edit
          docopt.py  # no need to edit

Note that all other listed files are overwritten (use version control!).
