#.rst:
#
# Creates build_info.h in the build directory.
# This file can be included into sources to print
# build information variables to the program output.
#
# autocmake.cfg configuration::
#
#   fetch: https://github.com/miroi/autocmake/raw/build_info/modules/build_info/build_info.h.in


set(_c_compiler             "unknown")
set(_c_compiler_flags       "unknown")
set(_cxx_compiler           "unknown")
set(_cxx_compiler_flags     "unknown")
set(_static_linking         "unknown")
set(_who_compiled           "unknown")
set(_host                   "unknown")


set(_fortran_compiler_id       "unknown")
if (CMAKE_Fortran_COMPILER_ID)
    set(_fortran_compiler_id ${CMAKE_Fortran_COMPILER_ID})
    message("-- Fortran compiler ID        : ${CMAKE_Fortran_COMPILER_ID}")
endif()

set(_fortran_compiler       "unknown")
if (CMAKE_Fortran_COMPILER)
    set(_fortran_compiler ${CMAKE_Fortran_COMPILER})
    message("-- Fortran compiler           : ${CMAKE_Fortran_COMPILER}")
endif()

set(_fortran_compiler_flags "unknown")
if (CMAKE_Fortran_FLAGS)
    set(_fortran_compiler_flags ${CMAKE_Fortran_FLAGS})
    message("-- Fortran compiler flags     : ${CMAKE_Fortran_FLAGS}")
endif()

set(_c_compiler_id       "unknown")
if (CMAKE_C_COMPILER_ID)
    set(_c_compiler_id ${CMAKE_C_COMPILER_ID})
    message("-- C compiler ID              : ${CMAKE_C_COMPILER_ID}")
endif()

set(_c_compiler       "unknown")
if (CMAKE_C_COMPILER)
    set(_c_compiler ${CMAKE_C_COMPILER})
    message("-- C compiler                 : ${CMAKE_C_COMPILER}")
endif()

set(_c_compiler_flags "unknown")
if (CMAKE_C_FLAGS)
    set(_c_compiler_flags ${CMAKE_C_FLAGS})
    message("-- C compiler flags           : ${CMAKE_C_FLAGS}")
endif()

set(_system_name            "unknown")
if (CMAKE_SYSTEM_NAME)
    set(_system_name ${CMAKE_SYSTEM_NAME})
    message("-- System name              : ${CMAKE_SYSTEM_NAME}")
endif()

set(_cmake_build_type         "unknown")
if (CMAKE_BUILD_TYPE)
    set(_cmake_build_type ${CMAKE_BUILD_TYPE})
    message("-- CMake build type         : ${CMAKE_BUILD_TYPE}")
endif()

set(_system                 "unknown")
if (CMAKE_SYSTEM)
    set(_system ${CMAKE_SYSTEM})
    message("-- System                   : ${CMAKE_SYSTEM}")
endif()

set(_cmake_version          "unknown")
if (CMAKE_VERSION)
    set(_cmake_version     ${CMAKE_VERSION})
    message("-- CMake version            : ${CMAKE_VERSION}")
endif()

set(_cmake_generator       "unknown")
if (CMAKE_GENERATOR)
    set(_cmake_generator     ${CMAKE_GENERATOR})
    message("-- CMake generator          : ${CMAKE_GENERATOR}")
endif()

# generate the build_info.h include file with defined set of variables
configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/build_info.h.in
    ${PROJECT_BINARY_DIR}/build_info.h
    @ONLY
)

add_custom_target(
    build_info
    ALL DEPENDS ${PROJECT_BINARY_DIR}/build_info.h
    )
