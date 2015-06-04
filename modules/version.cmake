# determine program version from file, example: "14.1"
# the reason why this information is stored
# in a file and not as cmake variable
# is that cmake-unaware programs can
# parse and use it (e.g. Sphinx)
if(EXISTS "${PROJECT_SOURCE_DIR}/VERSION")
    file(READ "${PROJECT_SOURCE_DIR}/VERSION" PROGRAM_VERSION)
    string(STRIP "${PROGRAM_VERSION}" PROGRAM_VERSION)
endif()
