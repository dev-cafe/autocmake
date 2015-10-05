

Contributing to the documentation
=================================

Contributions and patches to the documentation are most welcome.

This documentation is refreshed upon each push to the central repository.

The module reference documentation is generated from the module sources using
``#.rst:`` tags (compare for instance
http://autocmake.readthedocs.org/en/latest/module-reference.html#cc-cmake with
https://github.com/scisoft/autocmake/blob/master/modules/cc.cmake).

Please note that the lines following ``# autocmake.cfg configuration::`` are
understood by the ``update.py`` script to infer autocmake.cfg code from the
documentation.  As an example consider
https://github.com/scisoft/autocmake/blob/master/modules/cc.cmake#L20-L25.
Here, ``update.py`` will infer the configurations for ``docopt``, ``export``,
and ``define``.
