

Bootstrapping a new project
===========================


Bootstrapping Autocmake
-----------------------

Download the ``update.py`` and execute it with ``--self`` to fetch other
infrastructure files which will be needed to build the project::

  $ mkdir cmake  # does not have to be called "cmake" - take the name you prefer
  $ cd cmake
  $ wget https://github.com/coderefinery/autocmake/raw/master/update.py
  $ virtualenv venv
  $ source venv/bin/activate
  $ pip install pyyaml
  $ python update.py --self

On the MS Windows system, you can use the PowerShell wget-replacement::

  $ Invoke-WebRequest https://github.com/coderefinery/autocmake/raw/master/update.py -OutFile update.py

This creates (or updates) the following files (an existing ``autocmake.yml`` is
not overwritten by the script)::

  cmake/
      autocmake.yml      # edit this file
      update.py          # no need to edit
      autocmake/         # no need to edit
          ...            # no need to edit

Note that ``update.py`` and files under ``autocmake/``
are overwritten (use version control).


Generating the CMake infrastructure
-----------------------------------

Now customize ``autocmake.yml`` to your needs
(see :ref:`autocmake_yml`)
and then run the ``update.py`` script which
creates ``CMakeLists.txt`` and a setup script in the target path::

  $ python update.py ..

The script also downloads external CMake modules specified in ``autocmake.yml`` to a directory
called ``downloaded/``::

  cmake/
      autocmake.yml      # edit this file
      update.py          # no need to edit
      autocmake/         # no need to edit
          ...            # no need to edit
      downloaded/        # contains CMake modules fetched from the web


Building the project
--------------------

Now you have ``CMakeLists.txt`` and setup script in the project root and the project
can be built::

  $ cd ..
  $ python setup [-h]
  $ cd build
  $ make
