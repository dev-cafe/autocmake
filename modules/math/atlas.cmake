#.rst:
#
# Find and link to ATLAS.
#
# Variables defined::
#
#   ATLAS_FOUND
#   ATLAS_LIBRARIES
#   ATLAS_INCLUDE_DIR
#
# autocmake.cfg configuration::
#
#   docopt: --atlas Find and link to ATLAS [default: False].
#   define: '-DENABLE_ATLAS=%s' % arguments['--atlas']

option(ENABLE_ATLAS "Find and link to ATLAS" OFF)

if(ENABLE_ATLAS)
    set(BLA_VENDOR "ATLAS")
    find_package(BLAS REQUIRED)
    unset(BLA_VENDOR)
endif()
