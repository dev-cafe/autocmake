# (c) https://github.com/dev-cafe/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/dev-cafe/autocmake/blob/master/LICENSE

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
# autocmake.yml configuration::
#
#   docopt: "--atlas Find and link to ATLAS [default: False]."
#   define: "'-DENABLE_ATLAS={0}'.format(arguments['--atlas'])"

option(ENABLE_ATLAS "Find and link to ATLAS" OFF)

if(ENABLE_ATLAS)
    set(BLA_VENDOR "ATLAS")
    find_package(BLAS REQUIRED)
    unset(BLA_VENDOR)
endif()
