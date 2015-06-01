

Customizing the CMake modules
=============================

The CMake modules can be customized directly inside ``modules/`` but this is
not very convenient as the customizations may be overwritten by the
``boostrap.py`` script.

A better solution is to download the CMake modules that you wish you customize
to a separate directory and source the customized CMake modules in
``autocmake.cfg``.
