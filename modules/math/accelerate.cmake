#.rst:
#
# Find and link to ACCELERATE.
#
# Variables defined::
#
#   ACCELERATE_FOUND - describe me, uncached
#   ACCELERATE_LIBRARIES - describe me, uncached
#   ACCELERATE_INCLUDE_DIR - describe me, uncached
#
# autocmake.yml configuration::
#
#   url_root: https://github.com/coderefinery/autocmake/raw/yaml/
#   docopt: "--accelerate Find and link to ACCELERATE [default: False]."
#   define: "'-DENABLE_ACCELERATE={0}'.format(arguments['--accelerate'])"
#   fetch:
#     - "%(url_root)modules/find/find_libraries.cmake"
#     - "%(url_root)modules/find/find_include_files.cmake"

option(ENABLE_ACCELERATE "Find and link to ACCELERATE" OFF)

if(ENABLE_ACCELERATE)
    include(find_libraries)
    include(find_include_files)

    set(ACCELERATE_FOUND FALSE)
    set(ACCELERATE_LIBRARIES "NOTFOUND")
    set(ACCELERATE_INCLUDE_DIR "NOTFOUND")

    _find_library(Accelerate cblas_dgemm ACCELERATE_LIBRARIES)
    _find_include_dir(Accelerate.h /usr ACCELERATE_INCLUDE_DIR)

    if(NOT "${ACCELERATE_LIBRARIES}" MATCHES "NOTFOUND")
        if(NOT "${ACCELERATE_INCLUDE_DIR}" MATCHES "NOTFOUND")
            set(ACCELERATE_FOUND TRUE)
        endif()
    endif()
endif()
