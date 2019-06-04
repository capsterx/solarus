# Unit tests.
option(SOLARUS_TESTS "Generate the unit tests" ON)

if(SOLARUS_TESTS)
  add_subdirectory(tests)
endif()
