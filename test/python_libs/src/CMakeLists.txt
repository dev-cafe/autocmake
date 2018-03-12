add_executable(example example.cpp)
target_include_directories(example SYSTEM PUBLIC ${PYTHON_INCLUDE_DIRS})
target_link_libraries(example PUBLIC ${PYTHON_LIBRARIES})
