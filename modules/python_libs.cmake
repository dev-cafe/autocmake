# (c) https://github.com/dev-cafe/autocmake/blob/master/AUTHORS.md
# licensed under BSD-3: https://github.com/dev-cafe/autocmake/blob/master/LICENSE

#.rst:
#
# Detects Python libraries and headers.
# Detection is done basically by hand as the proper CMake package
# will not find libraries and headers matching the interpreter version.
#
# Dependencies::
#
#   python_interpreter         - Sets the Python interpreter for headers and libraries detection
#
# Variables used::
#
#   PYTHONINTERP_FOUND         - Was the Python executable found
#
# Variables defined::
#
#   PYTHONLIBS_FOUND           - have the Python libs been found
#   PYTHON_LIBRARIES           - path to the python library
#   PYTHON_INCLUDE_DIRS        - path to where Python.h is found
#   PYTHONLIBS_VERSION_STRING  - version of the Python libs found (since CMake 2.8.8)

if(PYTHONINTERP_FOUND)
   # Get Python include path from Python interpreter
   execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
                         "import distutils.sysconfig, sys; sys.stdout.write(distutils.sysconfig.get_python_inc())"
                  OUTPUT_VARIABLE _PYTHON_INCLUDE_PATH
                  RESULT_VARIABLE _PYTHON_INCLUDE_RESULT)
   # Get Python library path from interpreter
   execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
                        "from distutils.sysconfig import get_config_var; import sys; sys.stdout.write(get_config_var('LIBDIR'))"
                  OUTPUT_VARIABLE _PYTHON_LIB_PATH
                  RESULT_VARIABLE _PYTHON_LIB_RESULT)

   set(PYTHON_INCLUDE_DIR ${_PYTHON_INCLUDE_PATH} CACHE PATH "Path to a directory")
   set(_PYTHON_VERSION "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}")
   set(_PYTHON_VERSION_NO_DOTS "${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}")

   find_library(PYTHON_LIBRARY
     NAMES
     python${_PYTHON_VERSION_NO_DOTS}
     python${_PYTHON_VERSION}mu
     python${_PYTHON_VERSION}m
     python${_PYTHON_VERSION}u
     python${_PYTHON_VERSION}
     NO_DEFAULT_PATH
     HINTS
     "${_PYTHON_LIB_PATH}"
     DOC "Path to Python library file."
   )
   if (NOT EXISTS "${PYTHON_LIBRARY}")
       # redo with default paths
       find_library(PYTHON_LIBRARY
         NAMES
         python${_PYTHON_VERSION_NO_DOTS}
         python${_PYTHON_VERSION}mu
         python${_PYTHON_VERSION}m
         python${_PYTHON_VERSION}u
         python${_PYTHON_VERSION}
         HINTS
         "${_PYTHON_LIB_PATH}"
         DOC "Path to Python library file."
       )
   endif()

   mark_as_advanced(CLEAR PYTHON_EXECUTABLE)
   mark_as_advanced(FORCE PYTHON_LIBRARY)
   mark_as_advanced(FORCE PYTHON_INCLUDE_DIR)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PythonLibs
    REQUIRED_VARS
    PYTHON_LIBRARY
    PYTHON_INCLUDE_DIR
    PYTHON_EXECUTABLE)

if(NOT PYTHONLIBS_FOUND)
    message(FATAL_ERROR "Could NOT find PythonLibs - did you install the python-dev package?")
endif()

# Hook-up script variables to cache variables
set(PYTHON_LIBRARIES ${PYTHON_LIBRARY})
set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIR})
