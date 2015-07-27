

Customizing CMake modules
=========================

The ``update.py`` script assembles modules listed in ``autocmake.cfg`` into
``CMakeLists.txt``. Those that are fetched from the web are placed inside
``downloaded/``.  You have at least four options to customize downloaded CMake
modules:


Directly inside the generated directory
---------------------------------------

The CMake modules can be customized directly inside ``downloaded/`` but this is
the least elegant solution since the customizations may be overwritten by the
``update.py`` script (use version control).


Adapt local copies of CMake modules
-----------------------------------

A better solution is to download the CMake modules that you wish you customize
to a separate directory and source the customized CMake modules in
``autocmake.cfg``. Alternatively you can serve your custom
modules from your own http server.


Create own CMake modules
------------------------

Of course you can also create own modules and source them in ``autocmake.cfg``.


Contribute customizations to the "standard library"
---------------------------------------------------

If you think that your customization will be useful for other users as well,
you may consider contributing the changes directly to
https://github.com/scisoft/autocmake/. We very much encourage such
contributions. But we also strive for generality and portability.
