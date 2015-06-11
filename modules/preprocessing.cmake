set(CPP)

# forward preprocessing directly to the code
if(NOT "${CPP}" STREQUAL "")
    add_definitions(${CPP})
endif()

