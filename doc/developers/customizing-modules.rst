

Customizing CMake modules
=========================

The ``update.py`` script assembles modules listed in ``autocmake.cfg`` into
``CMakeLists.txt``. Those that are fetched from the web are placed inside
``downloaded/``.  You have several options to customize downloaded CMake
modules:


Directly inside the generated directory
---------------------------------------

The CMake modules can be customized directly inside ``downloaded/`` but this is
the least elegant solution since the customizations may be overwritten by the
``update.py`` script (use version control).


Adapt local copies of CMake modules
-----------------------------------

A slightly better solution is to download the CMake modules that you wish you customize
to a separate directory (e.g. ``custom/``) and source the customized CMake
modules in ``autocmake.cfg``. Alternatively you can serve your custom modules
from your own http server.


Fork and branch the CMake modules
---------------------------------

You can fork and branch the mainline Autocmake development and include
the branched customized versions. This will make it easier for you
to stay up-to-date with upstream development.


Overriding defaults
-------------------

Some modules use interpolations to set defaults, see for instance
https://github.com/coderefinery/autocmake/blob/master/modules/boost/boost.cmake#L33-L36.
These can be modified within ``autocmake.cfg``, e.g.:
https://github.com/coderefinery/autocmake/blob/master/test/boost_libs/cmake/autocmake.cfg#L9


Create own CMake modules
------------------------

Of course you can also create own modules and source them in ``autocmake.cfg``.


Contribute customizations to the "standard library"
---------------------------------------------------

If you think that your customization will be useful for other users as well,
you may consider contributing the changes directly to
https://github.com/coderefinery/autocmake/. We very much encourage such
contributions. But we also strive for generality and portability.
