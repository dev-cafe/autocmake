#.rst:
#
# Find and link to LAPACKE.
#
# Variables defined::
#
#   LAPACKE_FOUND - describe me, uncached
#   LAPACKE_LIBRARIES - describe me, uncached
#   LAPACKE_INCLUDE_DIR - describe me, uncached
#
# autocmake.cfg configuration::
#
#   docopt: --lapacke Find and link to LAPACKE [default: False].
#   define: '-DENABLE_LAPACKE=%s' % arguments['--lapacke']
#   fetch: https://github.com/scisoft/autocmake/raw/master/modules/find/find_libraries.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/find/find_include_files.cmake

option(ENABLE_LAPACKE "Find and link to LAPACKE" OFF)

if(ENABLE_LAPACKE)
    include(find_libraries)
    include(find_include_files)

    set(LAPACKE_FOUND FALSE)
    set(LAPACKE_LIBRARIES "NOTFOUND")
    set(LAPACKE_INCLUDE_DIR "NOTFOUND")

    _find_library(lapacke LAPACKE_dgesv LAPACKE_LIBRARIES)
    _find_include_dir(lapacke.h /usr LAPACKE_INCLUDE_DIR)

    if(NOT "${LAPACKE_LIBRARIES}" MATCHES "NOTFOUND")
        if(NOT "${LAPACKE_INCLUDE_DIR}" MATCHES "NOTFOUND")
            set(LAPACKE_FOUND TRUE)
        endif()
    endif()
endif()
