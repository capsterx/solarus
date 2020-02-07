# Declare the "solarus-testing" library target and its public/private sources
# Note: will be STATIC or SHARED depending on BUILD_SHARED_LIBS=<ON|OFF>
add_library(solarus-testing "")
target_sources(solarus-testing
  PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/include/tools/TestEnvironment.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/include/tools/TestEnvironment.inl"
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/tools/TestEnvironment.cpp"
)

# Declare the public/private libraries that "solarus-testing" depends on
target_link_libraries(solarus-testing
  PUBLIC
    solarus
)

# Set the build properties for "solarus-testing"
set_target_properties(solarus-testing PROPERTIES
  VERSION ${PROJECT_VERSION}
  SOVERSION ${PROJECT_VERSION_MAJOR}
)

# Set up the root path on OSX testing target
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set_target_properties(solarus-testing PROPERTIES
    MACOSX_RPATH ON
    BUILD_WITH_INSTALL_RPATH 1
    INSTALL_NAME_DIR "@rpath"
  )
endif()

# Set up install target for "solarus-testing"
if (SOLARUS_TESTS_INSTALL)
  install(TARGETS solarus-testing
    ARCHIVE DESTINATION ${SOLARUS_LIBRARY_INSTALL_DESTINATION}
    LIBRARY DESTINATION ${SOLARUS_LIBRARY_INSTALL_DESTINATION}
    RUNTIME DESTINATION ${SOLARUS_EXECUTABLE_INSTALL_DESTINATION}
  )
endif()
