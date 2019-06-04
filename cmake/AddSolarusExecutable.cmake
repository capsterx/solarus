# Declare the "solarus-run" executable target and its public/private sources
add_executable(solarus-run "")
target_sources(solarus-run
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/main/Main.cpp"
)

# Add the Solarus icon for Windows-based builds
if(MINGW)
  target_sources(solarus-run
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/cmake/win32/resources-mingw.rc"
  )
elseif(WIN32)
  target_sources(solarus-run
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/cmake/win32/resources.rc"
  )
endif()

# Declare the public/private libraries that "solarus-run" depends on
target_link_libraries(solarus-run
  PUBLIC
    solarus
)
