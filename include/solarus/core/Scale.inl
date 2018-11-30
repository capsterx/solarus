namespace Solarus {

constexpr Scale::Scale() = default;


/**
 * @brief Make a scale
 * @param s the scale in each dimension
 */
constexpr Scale::Scale(float s) : x(s),y(s) {}

/**
 * @brief Make a scale
 * @param x scale in x dimension
 * @param y scale in y dimension
 */
constexpr Scale::Scale(float x,float y) : x(x), y(y) {}

/**
 * @brief multiply scale in place
 * @param an other scale
 * @return this scale scaled by the other scale
 */
inline Scale& Scale::operator*=(const Scale& other) {
  x*=other.x;
  y*=other.y;
  return *this;
}

/**
 * @brief multiply this scale by a scalar
 * @param factor scalar
 * @return this scale multiplied by the scalar
 */
inline Scale& Scale::operator*=(float factor) {
  x*=factor;
  y*=factor;
  return *this;
}

inline Scale::operator glm::vec2() const {
  return {x,y};
}

/**
 * @brief multiply a Size by a scale
 * @param size a size
 * @param scale a scale
 * @return a new Size with component multiplied by the scale
 */
inline constexpr Size operator*(const Size& size, const Scale& scale) {
  return Size(size.width*scale.x,size.height*scale.y);
}

/**
 * @brief Multiply a Point by a scale, like a vector
 * @param point a point
 * @param scale a scale
 * @return a new Point with compenents multiplied by the scale
 */
inline constexpr Point operator*(const Point& point, const Scale& scale) {
  return Point(point.x*scale.x,point.y*scale.y);
}

inline constexpr Scale operator*(const Scale& a, const Scale& b) {
  return Scale(a.x*b.x,a.y*b.y);
}

inline constexpr Scale operator*(const Scale& a, float b) {
  return Scale(a.x*b,a.y*b);
}

inline constexpr Scale operator/(const Size& size, const Size& other) {
  return Scale(static_cast<float>(size.width)/static_cast<float>(other.width),
               static_cast<float>(size.height)/static_cast<float>(other.height));
}

}
