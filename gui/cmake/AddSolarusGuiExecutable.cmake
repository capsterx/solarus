# Declare the "solarus-launcher" executable target and its public/private sources
add_executable(solarus-launcher "")
target_sources(solarus-launcher
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
)

# Add the Solarus Launcher icon for Windows-based builds
if(MINGW)
  target_sources(solarus-launcher
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/resources/win32/resources-mingw.rc"
  )
elseif(WIN32)
  target_sources(solarus-launcher
    PRIVATE
      "${CMAKE_CURRENT_SOURCE_DIR}/resources/win32/resources.rc"
  )
endif()

# Declare the public/private libraries that "solarus-launcher" depends on
target_link_libraries(solarus-launcher
  PUBLIC
    solarus-gui
)
