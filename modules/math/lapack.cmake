# (c) https://github.com/coderefinery/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/coderefinery/autocmake/blob/master/LICENSE

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
# autocmake.yml configuration::
#
#   docopt: "--lapack Find and link to LAPACK [default: False]."
#   define: "'-DENABLE_LAPACK={0}'.format(arguments['--lapack'])"

option(ENABLE_LAPACK "Find and link to LAPACK" OFF)

if(ENABLE_LAPACK)
    find_package(LAPACK REQUIRED)
endif()
