#include <glm/gtc/matrix_transform.hpp>
#include <array>

namespace Solarus {

using namespace glm;

inline constexpr Transform::Transform(const Point& position, const Point& origin, const Scale& scale, double rotation)
  : position(position), origin(origin), scale(scale), rotation(rotation)
{

}

inline void Transform::compute_collision_data(const Transform& other, vec2& origin, vec2& vx, vec2& vy) const {
  mat4 b_to_w = inverse(other.get_glm_transform());
  mat4 w_to_a = get_glm_transform();
  mat4 b_to_a = b_to_w*w_to_a;
  vec4 orig_h = b_to_a * vec4(0,0,0,1);
  vec4 vx_h = b_to_a * vec4(1,0,0,0);
  vec4 vy_h = b_to_a * vec4(0,1,0,0);
  origin = vec2(orig_h);
  vx = vec2(vx_h);
  vy = vec2(vy_h);
}

static inline bool feq(float a, float b) {
  return std::fabs(a-b) < 1e-3;
}

inline bool Transform::aligned() const {
  return feq(scale.x,1) && feq(scale.y,1) && feq(rotation,0);
}

inline bool Transform::smaller_kernel_than(const Transform& other) const {
  return kernel_size() < other.kernel_size();
}

using Vecs = std::array<vec2,4>;
using Interval = std::pair<float,float>;

static inline Interval axis_projection(const vec2& axis, const Vecs& points) {
  float min = std::numeric_limits<float>::infinity();
  float max = -min;
  for(const auto& p : points) {
    float proj = dot(axis,p);
    min = std::fmin(min,proj);
    max = std::fmax(max,proj);
  }
  return std::make_pair(min,max);
}

static inline bool interval_intersect(const Interval& a, const Interval& b) {
  float max = std::fmin(a.second,b.second);
  float min = std::fmax(a.first,b.first);
  return max>min;
}

static inline Vecs make_points(const mat4& m, const Size& box) {
  return {
        vec2(m*vec4(0,0,0,1)),
        vec2(m*vec4(box.width,0,0,1)),
        vec2(m*vec4(box.width,box.height,0,1)),
        vec2(m*vec4(0,box.height,0,1))
  };
}

inline bool Transform::obb_intersect(const Size& size, const Transform& other, const Size& othersize) const {
  //Get transformations
  mat4 b_to_w = other.get_glm_transform();
  mat4 a_to_w = get_glm_transform();

  //Compute axes
  Vecs axises = {
    vec2(a_to_w*vec4(1,0,0,0)),
    vec2(a_to_w*vec4(0,1,0,0)),
    vec2(b_to_w*vec4(1,0,0,0)),
    vec2(b_to_w*vec4(0,1,0,0)),
  };

  auto points_a = make_points(a_to_w,size);
  auto points_b = make_points(b_to_w,othersize);

  for(const auto& axis : axises) {
    Interval a = axis_projection(axis,points_a);
    Interval b = axis_projection(axis,points_b);
    if(!interval_intersect(a,b)) {
      return false;
    }
  }
  return true;
}

inline float Transform::kernel_size() const {
  return std::fabs(scale.x*scale.y);
}

inline mat4 Transform::get_glm_transform() const {
  mat4 transform_trans_i = translate(mat4(),vec3(position.x+origin.x,position.y+origin.y,0));
  mat4 transform_rot = rotate(transform_trans_i,(float)rotation,vec3(0,0,-1));
  mat4 transform_scale = glm::scale(transform_rot,vec3(scale.x,scale.y,1));
  return translate(transform_scale,vec3(-origin.x,-origin.y,0));
}

}
