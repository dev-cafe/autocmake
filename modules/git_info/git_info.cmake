#.rst:
#
# Creates git_info.h in the build directory.
# This file can be included in sources to print
# Git repository version and status information
# to the program output.
#
# autocmake.cfg configuration::
#
#   fetch: https://github.com/scisoft/autocmake/raw/master/modules/git_info/git_info_sub.cmake
#          https://github.com/scisoft/autocmake/raw/master/modules/git_info/git_info.h.in


# note: cmake 2.8.2 has undefined variable CMAKE_CURRENT_LIST_DIR, 
# see https://public.kitware.com/Bug/print_bug_page.php?bug_id=11675
# workaround from Google : create CMAKE_CURRENT_LIST_DIR if it doesn't exist 
if(NOT DEFINED CMAKE_CURRENT_LIST_DIR)
    message(STATUS "The CMAKE_CURRENT_LIST_DIR variable defined in workaround")
    get_filename_component(CMAKE_CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
endif(NOT DEFINED CMAKE_CURRENT_LIST_DIR)
add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/git_info.h
    COMMAND ${CMAKE_COMMAND} -D_target_dir=${PROJECT_BINARY_DIR} -P git_info_sub.cmake
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    )

add_custom_target(
    git_info
    ALL DEPENDS ${PROJECT_BINARY_DIR}/git_info.h
    )
