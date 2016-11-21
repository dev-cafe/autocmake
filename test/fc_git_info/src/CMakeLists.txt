generate_git_info_header(${PROJECT_BINARY_DIR} git_info.h)

include_directories(${PROJECT_BINARY_DIR})

add_executable(example example.F90)
