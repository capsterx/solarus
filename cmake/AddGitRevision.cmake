# Get git short hash of current HEAD
find_package(Git QUIET)
if(GIT_FOUND AND EXISTS "${CMAKE_SOURCE_DIR}/.git/index")
  execute_process(
    COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    OUTPUT_VARIABLE SOLARUS_GIT_REVISION
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()
