# Generate config.h with useful configuration info.
include(CheckFunctionExists)
check_function_exists(mkstemp MKSTEMP_FUNCTION_EXIST)

include(CheckCXXSymbolExists)
check_cxx_symbol_exists(mkstemp "cstdlib" MKSTEMP_SYMBOL_EXIST)

if(MKSTEMP_FUNCTION_EXIST AND MKSTEMP_SYMBOL_EXIST)
  set(SOLARUS_HAVE_MKSTEMP 1)
endif()

include(CheckIncludeFiles)
check_include_files(unistd.h SOLARUS_HAVE_UNISTD_H)

# Define SOLARUS_HAVE_OPENGL to indicate if OpenGL is supported.
# Otherwise OpenGL ES is used.
if(OPENGL_FOUND)
  set(SOLARUS_HAVE_OPENGL 1)
endif()

configure_file("${CMAKE_SOURCE_DIR}/include/solarus/core/config.h.in" "${CMAKE_BINARY_DIR}/include/solarus/core/config.h")

