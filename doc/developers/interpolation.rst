
.. _interpolation:

Interpolation
=============

In a custom extension to the YAML specification you can define and reuse
variables like this (observe how we interpolate ``url_root``, ``major``,
``minor``, ``patch``, and ``components`` in this example)::

  url_root: https://github.com/dev-cafe/autocmake/raw/master/
  major: 1
  minor: 48
  patch: 0
  components: ""
  fetch:
    - "%(url_root)modules/boost/boost_unpack.cmake"
    - "%(url_root)modules/boost/boost_userconfig.cmake"
    - "%(url_root)modules/boost/boost_configure.cmake"
    - "%(url_root)modules/boost/boost_build.cmake"
    - "%(url_root)modules/boost/boost_install.cmake"
    - "%(url_root)modules/boost/boost_headers.cmake"
    - "%(url_root)modules/boost/boost_cleanup.cmake"
    - "http://sourceforge.net/projects/boost/files/boost/%(major).%(minor).%(patch)/boost_%(major)_%(minor)_%(patch).zip"
  docopt:
    - "--boost-headers=<BOOST_INCLUDEDIR> Include directories for Boost [default: '']."
    - "--boost-libraries=<BOOST_LIBRARYDIR> Library directories for Boost [default: '']."
    - "--build-boost=<FORCE_CUSTOM_BOOST> Deactivate Boost detection and build on-the-fly <ON/OFF> [default: OFF]."
  define:
    - "'-DBOOST_INCLUDEDIR=\"{0}\"'.format(arguments['--boost-headers'])"
    - "'-DBOOST_LIBRARYDIR=\"{0}\"'.format(arguments['--boost-libraries'])"
    - "'-DFORCE_CUSTOM_BOOST={0}'.format(arguments['--build-boost'])"
    - "'-DBOOST_MINIMUM_REQUIRED=\"%(major).%(minor).%(patch)\"'"
    - "'-DBOOST_COMPONENTS_REQUIRED=\"%(components)\"'"
