

Updating CMake modules
======================

To update CMake modules fetched from the web you need to run the ``update.py`` script::

  $ cd cmake
  $ python update.py ..

The CMake modules are not fetched or updated at configure time or build time.
In other words, if you never re-run ``update.py`` script and never modify the
CMake module files, then the CMake modules will remain forever frozen.


How to pin CMake modules to a certain version
---------------------------------------------

Sometimes you may want to avoid using the latest version of a CMake module and
rather fetch an older version, for example with the hash ``abcd123``. To
achieve this, instead of::

  [foo]
  source: https://github.com/coderefinery/autocmake/raw/master/modules/foo.cmake

pin the version to ``abcd123`` (you do not need to specify the full Git hash, a unique
beginning will do)::

  [foo]
  source: https://github.com/coderefinery/autocmake/raw/abcd123/modules/foo.cmake
