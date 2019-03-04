/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/core/Debug.h"
#include "solarus/core/Geometry.h"
#include "solarus/core/Map.h"
#include "solarus/core/System.h"
#include "solarus/entities/Entities.h"
#include "solarus/entities/Entity.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/movements/CircleMovement.h"
#include <sstream>

namespace Solarus {

/**
 * \brief Creates a circle movement.
 */
CircleMovement::CircleMovement():

  Movement(),
  center_entity(nullptr),
  current_angle(0.0),
  initial_angle(0.0),
  angle_increment(1),
  next_angle_change_date(static_cast<double>(System::now())),
  angle_change_delay(5.0),
  angular_speed(1000.0 / Geometry::degrees_to_radians(angle_change_delay)),
  current_radius(0),
  wanted_radius(0),
  previous_radius(0),
  radius_increment(0),
  next_radius_change_date(System::now()),
  radius_change_delay(0),
  duration(0),
  end_movement_date(0),
  max_rotations(0),
  num_increments(0),
  num_rotations(0),
  loop_delay(0),
  restart_date(System::now()) {

}

/**
 * \brief Returns the center of the circles.
 * \return The center point.
 */
Point CircleMovement::get_center() const {

  Point center = this->center_point;
  if (center_entity != nullptr) {
    center += center_entity->get_xy();
  }
  return center;
}

/**
 * \brief Sets the center of the circles.
 *
 * The movement will make circles around the specified fixed point.
 *
 * \param center_point Center of the circles to make.
 */
void CircleMovement::set_center(const Point& center_point) {

  this->center_entity = nullptr;
  this->center_point = center_point;
  recompute_position();
}

/**
 * \brief Sets the center of the circles.
 *
 * The movement will make circles around the specified (possibly moving) entity.
 *
 * \param center_entity the entity around which you want to make circles
 * \param x X coordinate of where the center should be placed relative to the entity's origin.
 * \param y Y coordinate of where the center should be placed relative to the entity's origin.
 */
void CircleMovement::set_center(
    const EntityPtr& center_entity,
    int x,
    int y
) {
  this->center_entity = center_entity;
  this->center_point = { x, y };
  recompute_position();
}

/**
 * \brief Returns the radius of the circles.
 * \return The radius in pixels.
 */
int CircleMovement::get_radius() const {
  return wanted_radius;
}

/**
 * \brief Sets the radius of the circles.
 * \param radius The radius in pixels.
 */
void CircleMovement::set_radius(int radius) {

  if (radius < 0) {
    std::ostringstream oss;
    oss << "Invalid radius: " << radius;
    Debug::die(oss.str());
  }

  this->wanted_radius = radius;
  if (radius_change_delay == 0) {
    if (is_started()) {
      this->current_radius = wanted_radius;
    }
  }
  else {
    this->radius_increment = (radius > this->current_radius) ? 1 : -1;
    if (is_started()) {
      this->next_radius_change_date = System::now();
    }
  }
  recompute_position();
}

/**
 * \brief Returns the speed of the radius variations.
 * \return The speed in pixels per second, or 0 if radius variations are immediate.
 */
int CircleMovement::get_radius_speed() const {

  return radius_change_delay == 0 ? 0 : 1000 / radius_change_delay;
}

/**
 * \brief Sets the radius to be updated immediately or gradually towards its wanted value.
 *
 * Use set_radius() to specify the wanted value.
 *
 * \param radius_speed Speed of the radius variation (number of pixels per second),
 * or 0 to update it immediately.
 */
void CircleMovement::set_radius_speed(int radius_speed) {

  if (radius_speed < 0) {
    std::ostringstream oss;
    oss << "Invalid radius speed: " << radius_speed;
    Debug::die(oss.str());
  }

  if (radius_speed == 0) {
    this->radius_change_delay = 0;
  }
  else {
    this->radius_change_delay = 1000 / radius_speed;
  }

  set_radius(wanted_radius);
}

/**
 * \brief Returns the speed of the angle variation.
 * \return The number of radians made per second.
 */
double CircleMovement::get_angular_speed() const {
  return angular_speed;
}

/**
 * \brief Sets the speed of the angle variation.
 * \param angle_speed Number of radians to make per second.
 */
void CircleMovement::set_angular_speed(double angular_speed) {

  if (angular_speed <= 0.0) {
    std::ostringstream oss;
    oss << "Invalid angle speed: " << angular_speed;
    Debug::die(oss.str());
  }

  this->angular_speed = angular_speed;
  this->angle_change_delay = 1000.0 / Geometry::radians_to_degrees(angular_speed);
  this->next_angle_change_date = static_cast<double>(System::now());
  recompute_position();
}

/**
 * \brief Returns the angle of the current position on the circle.
 * \return The angle in radians.
 */
double CircleMovement::get_angle_from_center() const {

  return current_angle;
}

/**
 * \brief Sets the position as an angle from the center.
 * \param angle_from_center The angle in radians.
 */
void CircleMovement::set_angle_from_center(double angle_from_center) {

  // Normalize the angle.
  angle_from_center = std::fmod(angle_from_center + Geometry::TWO_PI, Geometry::TWO_PI);

  this->initial_angle = angle_from_center;

  start();
}

/**
 * \brief Returns the angle from where the first circle starts.
 * \return The angle in radians.
 */
double CircleMovement::get_initial_angle() const {

  return initial_angle;
}

/**
 * \brief Returns the direction of the circles.
 * \return \c true if circles are clockwise.
 */
bool CircleMovement::is_clockwise() const {

  return angle_increment < 0;
}

/**
 * \brief Sets the direction of circles.
 * \param clockwise \c true to make clockwise circles.
 */
void CircleMovement::set_clockwise(bool clockwise) {

  this->angle_increment = clockwise ? -1 : 1;
}

/**
 * \brief Returns the maximum duration of the movement.
 *
 * When this delay is reached, the movement stops.
 * Note that if the radius changes gradually, the movement will continue
 * for a while until the radius reaches zero.
 *
 * \return Duration of the movement in milliseconds (0 means unlimited).
 */
uint32_t CircleMovement::get_duration() const {

  return duration;
}

/**
 * \brief Sets the maximum duration of the movement.
 *
 * When this delay is reached, the movement stops.
 * Note that if the radius changes gradually, the movement will continue
 * for a while until the radius reaches zero.
 *
 * \param duration Duration of the movement in milliseconds (0 means unlimited).
 */
void CircleMovement::set_duration(uint32_t duration) {

  this->duration = duration;
  if (duration != 0 && is_started()) {
    this->end_movement_date = System::now() + duration;
  }
}

/**
 * \brief Returns the number of rotations of the movement.
 *
 * When this number of rotations is reached, the movement stops.
 * Note that if the radius changes gradually, the movement will continue
 * for a while until the radius reaches zero.
 *
 * \return The number of rotations to make (0 means unlimited).
 */
int CircleMovement::get_max_rotations() const {

  return max_rotations;
}

/**
 * \brief Sets the number of rotations of the movement.
 *
 * When this number of rotations is reached, the movement stops.
 * Note that is the radius changes gradually, the movement will continue
 * for a while until the radius reaches zero.
 *
 * \param max_rotations The number of rotations to make (0 means unlimited).
 */
void CircleMovement::set_max_rotations(int max_rotations) {

  if (max_rotations < 0) {
    std::ostringstream oss;
    oss << "Invalid maximum rotations number: " << max_rotations;
    Debug::die(oss.str());
  }

  this->max_rotations = max_rotations;
  this->num_rotations = 0;
  this->num_increments = 0;
}

/**
 * \return Returns the delay after which the movement restarts.
 * \return The delay in milliseconds (0 means no restart).
 */
uint32_t CircleMovement::get_loop() const {

  return loop_delay;
}

/**
 * \brief Makes the movement restart after a delay when it is finished.
 * \param delay The movement will restart after this delay in milliseconds (0 to avoid this).
 */
void CircleMovement::set_loop(uint32_t delay) {

  this->loop_delay = delay;
  if (delay != 0 && is_stopped()) {
    this->restart_date = System::now() + delay;
  }
}

/**
 * \brief Updates the movement.
 */
void CircleMovement::update() {

  if (center_entity != nullptr && center_entity->is_being_removed()) {
    set_center(Point(
          center_entity->get_x() + center_point.x,
          center_entity->get_y() + center_point.y));
  }

  if (is_suspended()) {
    return;
  }

  bool update_needed = false;
  uint32_t now = System::now();

  // Maybe it is time to stop or to restart.
  if (current_radius != 0 &&
      duration != 0 &&
      now >= end_movement_date &&
      wanted_radius != 0) {
    stop();
  }
  else if (current_radius == 0 &&
           loop_delay != 0 &&
           now >= restart_date &&
           wanted_radius == 0
  ) {
    set_radius(previous_radius);
    start();
  }

  // Update the angle.
  if (is_started()) {
    while (now >= next_angle_change_date) {

      current_angle += Geometry::degrees_to_radians(angle_increment);
      current_angle = std::fmod(current_angle + Geometry::TWO_PI, Geometry::TWO_PI);
      ++num_increments;
      if (num_increments == 360) {
        num_rotations++;
        num_increments = 0;

        if (num_rotations == max_rotations) {
          stop();
        }
      }

      next_angle_change_date += angle_change_delay;
      update_needed = true;
    }
  }

  // Update the radius.
  while (current_radius != wanted_radius &&
         now >= next_radius_change_date) {

    current_radius += radius_increment;

    next_radius_change_date += radius_change_delay;
    update_needed = true;
  }

  // The center may have moved.
  if (center_entity != nullptr) {
    update_needed = true;
  }

  if (update_needed) {
    recompute_position();
  }

  // Do this at last so that Movement::update() knows if we are finished.
  Movement::update();
}

/**
 * \brief Computes the position of the object controlled by this movement.
 *
 * This function should be called whenever the angle, the radius or the center changes.
 */
void CircleMovement::recompute_position() {

  Point center = get_center();
  Point xy = Geometry::get_xy(center, current_angle, current_radius);
  if (get_entity() == nullptr
      || !test_collision_with_obstacles(xy - get_entity()->get_xy())) {
    set_xy(xy);
    notify_position_changed();
  }
  else {
    notify_obstacle_reached();
  }
}

/**
 * \brief Suspends or resumes the movement
 * \param suspended true to suspend the movement, false to resume it
 */
void CircleMovement::set_suspended(bool suspended) {

  Movement::set_suspended(suspended);

  if (get_when_suspended() != 0) {
    uint32_t diff = System::now() - get_when_suspended();
    next_angle_change_date += diff;
    next_radius_change_date += diff;
    end_movement_date += diff;
    restart_date += diff;
  }
}

/**
 * \brief Starts the circle movement.
 */
void CircleMovement::start() {

  current_angle = initial_angle;
  next_angle_change_date = System::now();
  num_increments = 0;
  num_rotations = 0;

  if (duration != 0) {
    end_movement_date = System::now() + duration;
  }

  if (radius_change_delay == 0) {
    current_radius = wanted_radius;
  }
  else {
    next_radius_change_date = System::now();
  }
  recompute_position();
}

/**
 * \brief Returns whether this movement is running.
 * \return true if the movement is started
 */
bool CircleMovement::is_started() const {
  return current_radius != 0 || wanted_radius != 0;
}

/**
 * \brief Returns whether this movement is finished.
 * \return true if this movement is finished
 */
bool CircleMovement::is_finished() const {
  return is_stopped();
}

/**
 * \brief Stops the movement.
 */
void CircleMovement::stop() {

  previous_radius = current_radius;
  set_radius(0);

  if (loop_delay != 0) {
    restart_date = System::now() + loop_delay;
  }
  recompute_position();
}

/**
 * \copydoc Movement::get_displayed_direction4()
 */
int CircleMovement::get_displayed_direction4() const {

  int tangent_angle = Geometry::radians_to_degrees(current_angle) +
      (is_clockwise() ? (-90) : 90);
  int direction = (tangent_angle + 45 + 360) / 90;
  return direction % 4;
}

/**
 * \brief Returns the name identifying this type in Lua.
 * \return the name identifying this type in Lua
 */
const std::string& CircleMovement::get_lua_type_name() const {
  return LuaContext::movement_circle_module_name;
}

}

