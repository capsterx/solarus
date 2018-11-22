#include "solarus/graphics/SurfaceImpl.h"

namespace Solarus {

SurfaceImpl::~SurfaceImpl() {

}

/**
 * @brief is_premultiplied
 * @return
 */
bool SurfaceImpl::is_premultiplied() const {
  return premultiplied;
}

/**
 * @brief set_premultiplied
 */
void SurfaceImpl::set_premultiplied(bool a_premultiplied) {
  premultiplied = a_premultiplied;
}
}
