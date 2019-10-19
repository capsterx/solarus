# As Qt generates ui header files, the build directory
# needs to be an include directory as well
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Tell CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)

include(cmake/AddDependencies.cmake)
include(cmake/AddIncludeDirectories.cmake)
include(cmake/AddSolarusGuiLibrary.cmake)
include(cmake/AddSolarusGuiExecutable.cmake)
include(cmake/AddInstallTargets.cmake)
include(cmake/AddUninstallTargets.cmake)
include(cmake/AddDefines.cmake)
