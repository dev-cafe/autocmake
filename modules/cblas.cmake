#.rst:
#
# Find and link to CBLAS.
#
# Variables defined::
#
#   CBLAS_FOUND - describe me, uncached
#   CBLAS_LIBRARIES - describe me, uncached
#   CBLAS_INCLUDE_DIR - describe me, uncached
#
# autocmake.cfg configuration::
#
#   docopt: --cblas Find and link to CBLAS [default: False].
#   define: '-DENABLE_CBLAS=%s' % arguments['--cblas']
#   fetch: https://github.com/scisoft/autocmake/raw/master/modules/find/find_libraries.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/find/find_include_files.cmake

option(ENABLE_CBLAS "Find and link to CBLAS" OFF)

if(ENABLE_CBLAS)
    include(find_libraries)
    include(find_include_files)

    set(CBLAS_FOUND FALSE)
    set(CBLAS_LIBRARIES "NOTFOUND")
    set(CBLAS_INCLUDE_DIR "NOTFOUND")

    if(APPLE)
        _find_library(Accelerate cblas_dgemm CBLAS_LIBRARIES)
        _find_include_dir(Accelerate.h /usr CBLAS_INCLUDE_DIR)
    else()
        _find_library(cblas cblas_dgemm CBLAS_LIBRARIES)
        _find_include_dir(cblas.h /usr CBLAS_INCLUDE_DIR)
    endif()

    if(NOT "${CBLAS_LIBRARIES}" STREQUAL "NOTFOUND")
        if(NOT "${CBLAS_INCLUDE_DIR}" STREQUAL "NOTFOUND")
            set(CBLAS_FOUND TRUE)
        endif()
    endif()
endif()
