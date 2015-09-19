#.rst:
#
# Find and link to BLAS.
#
# Variables defined::
#
#   BLAS_FOUND - describe me, uncached
#   BLAS_LIBRARIES - describe me, uncached
#   BLAS_INCLUDE_DIR - describe me, uncached
#
# autocmake.cfg configuration::
#
#   docopt: --blas Find and link to BLAS [default: False].
#   define: '-DENABLE_BLAS=%s' % arguments['--blas']

option(ENABLE_BLAS "Find and link to BLAS" OFF)

if(ENABLE_BLAS)
    find_package(BLAS REQUIRED)
endif()
