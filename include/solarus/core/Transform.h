#ifndef SOLARUS_TRANSFORM_H
#define SOLARUS_TRANSFORM_H

#include "solarus/core/Point.h"
#include "solarus/core/Scale.h"
#include <glm/vec2.hpp>
#include <glm/mat4x4.hpp>

namespace Solarus {

/**
 * @brief Wrapper class that hold transform informations
 *
 * Transform information allows to compute usefull data, for example transforms to other transforms
 */
class Transform
{
public:
  inline constexpr Transform(const Point& position, const Point& origin, const Scale& scale, double rotation);
  inline void compute_collision_data(const Transform& other, glm::vec2& origin, glm::vec2& vx, glm::vec2& vy) const;
  inline glm::mat4 get_glm_transform() const;
  inline bool aligned() const;
  inline bool smaller_kernel_than(const Transform& other) const;
  inline bool obb_intersect(const Size& size, const Transform& other, const Size& othersize) const;
  const Point& position;               /**< Position on the map/the screen*/
  const Point& origin;                 /**< pivot for the transformations (rot,scale) of the object*/
  const Scale& scale;                  /**< Scale of the object around transform_origin*/
  double rotation = 0;                 /**< Rotation of the object around transform_origin*/
private:
  inline float kernel_size() const;
};

}
#include "Transform.inl"

#endif // TRANSFORM_H
