

Customizing the CMake modules
=============================

You have at least four options to customize CMake modules:


Directly inside the generated modules directory
-----------------------------------------------

The CMake modules can be customized directly inside ``modules/`` but this is
the least elegant solution since the customizations may be overwritten by the
``boostrap.py`` script.


Adapt local copies of CMake modules
-----------------------------------

A better solution is to download the CMake modules that you wish you customize
to a separate directory and source the customized CMake modules in
``autocmake.cfg``.


Create own CMake modules
------------------------

Of course you can also create own modules and source them in ``autocmake.cfg``.
Sometimes you have to.


Contribute customizations to the "standard library"
---------------------------------------------------

If you think that your customization will be useful for other users as well,
you may consider contributing the changes directly to
https://github.com/scisoft/autocmake/. We very much encourage such
contributions. But we of course also strive for generality and portability.
