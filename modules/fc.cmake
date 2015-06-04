#.rst:
#
# Adds Fortran support.
# Appends EXTRA_Fortran_FLAGS to CMAKE_Fortran_FLAGS.
# If environment variable FCFLAGS is set, then these flags are used
# and no other flags are appended.
#
# Defines::
#
#   CMAKE_Fortran_MODULE_DIRECTORY (${PROJECT_BINARY_DIR}/include/fortran)

enable_language(Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/include/fortran)

if(NOT DEFINED CMAKE_Fortran_COMPILER_ID)
    message(FATAL_ERROR "CMAKE_Fortran_COMPILER_ID variable is not defined!")
endif()

if(NOT CMAKE_Fortran_COMPILER_WORKS)
    message(FATAL_ERROR "CMAKE_Fortran_COMPILER_WORKS is false!")
endif()

if(DEFINED EXTRA_Fortran_FLAGS)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${EXTRA_Fortran_FLAGS}")
endif()

if(DEFINED ENV{FCFLAGS})
    set(CMAKE_Fortran_FLAGS "$ENV{FCFLAGS}")
endif()
