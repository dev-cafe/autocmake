

Customizing CMake modules
=========================

The ``update.py`` script assembles modules listed in ``autocmake.yml`` into
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
modules in ``autocmake.yml``. Alternatively you can serve your custom modules
from your own http server.


Fork and branch the CMake modules
---------------------------------

You can fork and branch the mainline Autocmake development and include
the branched customized versions. This will make it easier for you
to stay up-to-date with upstream development.


Overriding settings
-------------------

If you source a module which contains directives such as
``define``,
``docopt``,
``export``, or
``fetch``, and you wish to modify those,
then you can override these settings in ``autocmake.yml``.
Settings in ``autocmake.yml`` take precedence over
settings imported by a sourced module.

As an example consider the Boost module which defines and uses
interpolation variables ``major``, ``minor``, ``patch``, and ``components``, see
https://github.com/coderefinery/autocmake/blob/master/modules/boost/boost.cmake#L52-L55.

The recommended way to customize these is in ``autocmake.yml``, e.g.:
https://github.com/coderefinery/autocmake/blob/master/test/boost_libs/cmake/autocmake.yml#L12-L17.


Create own CMake modules
------------------------

Of course you can also create own modules and source them in ``autocmake.yml``.


Contribute customizations to the "standard library"
---------------------------------------------------

If you think that your customization will be useful for other users as well,
you may consider contributing the changes directly to
https://github.com/coderefinery/autocmake/. We very much encourage such
contributions. But we also strive for generality and portability.
