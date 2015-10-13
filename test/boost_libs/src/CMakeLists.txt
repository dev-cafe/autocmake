add_executable(example example.cpp)

if(BUILD_CUSTOM_BOOST)
    add_dependencies(example custom_boost)
endif()

target_link_libraries(example ${Boost_MPI_LIBRARY} ${Boost_SERIALIZATION_LIBRARY} ${MPI_CXX_LIBRARIES}
                              ${Boost_PYTHON_LIBRARY} ${PYTHON_LIBRARIES})
