#.rst:
#
# Determine program version from file "VERSION" (example: "14.1")
# The reason why this information is stored
# in a file and not as CMake variable is that CMake-unaware programs can parse
# and use it (e.g. Sphinx). Also web-based hosting frontends such as GitLab
# automatically use the file "VERSION" if present.
#
# Variables defined::
#
#   PROGRAM_VERSION
#
# Example autocmake.cfg entry::
#
#   [version]
#   source: https://github.com/scisoft/autocmake/raw/master/modules/version.cmake

if(EXISTS "${PROJECT_SOURCE_DIR}/VERSION")
    file(READ "${PROJECT_SOURCE_DIR}/VERSION" PROGRAM_VERSION)
    string(STRIP "${PROGRAM_VERSION}" PROGRAM_VERSION)
endif()
