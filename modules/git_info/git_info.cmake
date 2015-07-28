#.rst:
#
# Creates git_info.h in the build directory.
# This file can be included in sources to print
# Git repository version and status information
# to the program output.

add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/git_info.h
    COMMAND ${CMAKE_COMMAND} -D_target_dir=${PROJECT_BINARY_DIR} -P git_info_sub.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    )

add_custom_target(
    check
    ALL DEPENDS ${PROJECT_BINARY_DIR}/git_info.h
    )
