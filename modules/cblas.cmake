#.rst:
#
# Detect and link to CBLAS. Work in progress.
#
# Variables used::
#
#   ENABLE_STATIC_LINKING
#
# Variables defined::
#
#   CBLAS_FOUND - describe me, uncached
#   CBLAS_LIBRARIES - describe me, uncached
#   CBLAS_INCLUDE_DIR - describe me, uncached
#
# autocmake.cfg configuration::
#
#   docopt: --cblas Detect and link to CBLAS [default: False].
#   define: '-DENABLE_CBLAS=%s' % arguments['--cblas']

option(ENABLE_CBLAS "Enable CBLAS" OFF)

if(ENABLE_CBLAS)
    if(ENABLE_STATIC_LINKING)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    endif()

    include(CheckIncludeFile)

    function(_find_include_dir _names _hints _result)
        find_path(_include_dir
            NAMES ${_names}
            HINTS ${_hints}
        )
        set(_all_include_files_work TRUE)
        foreach(_name ${_names})
            check_include_file(${_include_dir}/${_name} _include_file_works)
            set(_all_include_files_work (${_all_include_files_work} AND ${_include_file_works}))
        endforeach()
        if(${_all_include_files_work})
            set(${_result} ${_include_dir} PARENT_SCOPE)
        endif()
    endfunction()

    include(CheckFunctionExists)

    function(_find_library _names _check_function _result)
        if(APPLE)
            find_library(_lib
                NAMES ${_names}
                PATHS /usr/local/lib /usr/lib /usr/local/lib64 /usr/lib64
                ENV DYLD_LIBRARY_PATH
                )
        else()
            find_library(_lib
                NAMES ${_names}
                PATHS /usr/local/lib /usr/lib /usr/local/lib64 /usr/lib64
                ENV LD_LIBRARY_PATH
                )
        endif()
        set(CMAKE_REQUIRED_LIBRARIES ${_lib})
        check_function_exists(${_check_function} _library_works)
        if(${_library_works})
            set(${_result} ${_lib} PARENT_SCOPE)
        endif()
    endfunction()

    set(CBLAS_FOUND FALSE)

    set(CBLAS_INCLUDE_DIR "undefined")
    _find_include_dir(cblas.h /usr CBLAS_INCLUDE_DIR)

    set(CBLAS_LIBRARIES "undefined")
    _find_library(cblas cblas_dgemm CBLAS_LIBRARIES)

    if(NOT ${CBLAS_INCLUDE_DIR} STREQUAL "undefined" AND NOT ${CBLAS_LIBRARIES} STREQUAL "undefined")
        set(CBLAS_FOUND TRUE)
    endif()
endif()
