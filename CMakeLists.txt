cmake_minimum_required(VERSION 3.1)

# Android: version information must be updated manually in AndroidConfig.h
project(solarus-engine VERSION 1.6.2)

include(cmake/AddGitRevision.cmake)
include(cmake/AddDefines.cmake)
include(cmake/AddCompilationFlags.cmake)
include(cmake/AddDependencies.cmake)
include(cmake/AddIncludeDirectories.cmake)
include(cmake/AddConfigurationHeader.cmake)
include(cmake/AddSolarusLibrary.cmake)
include(cmake/AddSolarusExecutable.cmake)
include(cmake/AddInstallTargets.cmake)
include(cmake/AddUninstallTargets.cmake)
include(cmake/AddUnitTests.cmake)
include(cmake/AddGui.cmake)
