#.rst:
#
# Find and link to BLAS.
#
# Variables defined::
#
#   BLAS_FOUND
#   BLAS_LIBRARIES
#   BLAS_INCLUDE_DIR
#
# autocmake.cfg configuration::
#
#   docopt: --blas Find and link to BLAS [default: False].
#   define: '-DENABLE_BLAS={0}'.format(arguments['--blas'])

option(ENABLE_BLAS "Find and link to BLAS" OFF)

if(ENABLE_BLAS)
    find_package(BLAS REQUIRED)
endif()
