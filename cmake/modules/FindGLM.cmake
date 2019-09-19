# FindGLM - attempts to locate the glm matrix/vector library.
#           Minimum compatible version is GLM 0.9.5.0
#
# This module defines the following variables (on success):
#   GLM_INCLUDE_DIRS, where to find glm/glm.hpp
#   GLM_FOUND, if the library was successfully located
#   GLM_VERSION_STRING
#    Human-readable string containing the version of GLM.
#

# locate GLM header
find_path(GLM_INCLUDE_DIR "glm/glm.hpp"
  HINTS
  $ENV{GLM_DIR}
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local/include/glm
  /usr/include/glm
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
)

# extract GLM version
if(GLM_INCLUDE_DIR AND EXISTS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp")
  file(STRINGS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp" GLM_VERSION_MAJOR_LINE REGEX "^#define[ \t]+GLM_VERSION_MAJOR[ \t]+[0-9]+$")
  file(STRINGS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp" GLM_VERSION_MINOR_LINE REGEX "^#define[ \t]+GLM_VERSION_MINOR[ \t]+[0-9]+$")
  file(STRINGS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp" GLM_VERSION_PATCH_LINE REGEX "^#define[ \t]+GLM_VERSION_PATCH[ \t]+[0-9]+$")
  file(STRINGS "${GLM_INCLUDE_DIR}/glm/detail/setup.hpp" GLM_VERSION_REVISION_LINE REGEX "^#define[ \t]+GLM_VERSION_REVISION[ \t]+[0-9]+$")
  string(REGEX REPLACE "^#define[ \t]+GLM_VERSION_MAJOR[ \t]+([0-9]+)$" "\\1" GLM_VERSION_MAJOR "${GLM_VERSION_MAJOR_LINE}")
  string(REGEX REPLACE "^#define[ \t]+GLM_VERSION_MINOR[ \t]+([0-9]+)$" "\\1" GLM_VERSION_MINOR "${GLM_VERSION_MINOR_LINE}")
  string(REGEX REPLACE "^#define[ \t]+GLM_VERSION_PATCH[ \t]+([0-9]+)$" "\\1" GLM_VERSION_PATCH "${GLM_VERSION_PATCH_LINE}")
  string(REGEX REPLACE "^#define[ \t]+GLM_VERSION_REVISION[ \t]+([0-9]+)$" "\\1" GLM_VERSION_REVISION "${GLM_VERSION_REVISION_LINE}")
  set(GLM_VERSION_STRING ${GLM_VERSION_MAJOR}.${GLM_VERSION_MINOR}.${GLM_VERSION_PATCH}.${GLM_VERSION_REVISION})
  unset(GLM_VERSION_MAJOR_LINE)
  unset(GLM_VERSION_MINOR_LINE)
  unset(GLM_VERSION_PATCH_LINE)
  unset(GLM_VERSION_REVISION_LINE)
  unset(GLM_VERSION_MAJOR)
  unset(GLM_VERSION_MINOR)
  unset(GLM_VERSION_PATCH)
  unset(GLM_VERSION_REVISION)
endif()

# handle GLM found
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GLM
  REQUIRED_VARS GLM_INCLUDE_DIR
  VERSION_VAR GLM_VERSION_STRING
)

# Enable GLM experimental extensions for GLM 0.9.9.0 to 0.9.9.3
if(GLM_VERSION_STRING VERSION_GREATER_EQUAL 0.9.9.0 AND GLM_VERSION_STRING VERSION_LESS_EQUAL 0.9.9.3)
  add_definitions(-DGLM_ENABLE_EXPERIMENTAL)
endif()
