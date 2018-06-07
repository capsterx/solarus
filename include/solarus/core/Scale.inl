namespace Solarus {

constexpr Scale::Scale() = default;
constexpr Scale::Scale(float x,float y) : x(x), y(y) {}

inline Scale& Scale::operator*=(const Scale& other) {
  x*=other.x;
  y*=other.y;
  return *this;
}

inline Scale& Scale::operator*=(float factor) {
  x*=factor;
  y*=factor;
  return *this;
}

inline constexpr Size operator*(const Size& size, const Scale& scale) {
  return Size(size.width*scale.x,size.height*scale.y);
}

inline constexpr Point operator*(const Point& point, const Scale& scale) {
  return Point(point.x*scale.x,point.y*scale.y);
}

inline constexpr Scale operator*(const Scale& a, const Scale& b) {
  return Scale(a.x*b.x,a.y*b.y);
}

inline constexpr Scale operator*(const Scale& a, float b) {
  return Scale(a.x*b,a.y*b);
}

}
