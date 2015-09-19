#.rst:
#
# Find and link to LAPACK.
#
# Variables defined::
#
#   LAPACK_FOUND
#   LAPACK_LIBRARIES
#   LAPACK_INCLUDE_DIR
#
# autocmake.cfg configuration::
#
#   docopt: --lapack Find and link to LAPACK [default: False].
#   define: '-DENABLE_LAPACK=%s' % arguments['--lapack']

option(ENABLE_LAPACK "Find and link to LAPACK" OFF)

if(ENABLE_LAPACK)
    find_package(LAPACK REQUIRED)
endif()
