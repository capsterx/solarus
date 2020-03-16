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
#ifndef SOLARUS_CIRCLE_MOVEMENT_H
#define SOLARUS_CIRCLE_MOVEMENT_H

#include "solarus/core/Common.h"
#include "solarus/entities/EntityPtr.h"
#include "solarus/movements/Movement.h"
#include <cstdint>
#include <string>

namespace Solarus {

/**
 * \brief Movement that makes circles around a center.
 *
 * This movement is used by entities that makes a circle around a center point or another entity.
 */
class CircleMovement: public Movement {

  public:

    // Creation and destruction.
    CircleMovement();

    // State.
    void update() override;
    void set_suspended(bool suspended) override;
    void start();
    void stop() override;
    bool is_started() const override;
    bool is_finished() const override;

    // Properties.
    Point get_center() const;
    void set_center(const Point& center_point);
    void set_center(
        const EntityPtr& center_entity,
        int x = 0,
        int y = 0
    );
    int get_radius() const;
    void set_radius(int radius);
    int get_radius_speed() const;
    void set_radius_speed(int radius_speed);
    double get_angular_speed() const;
    void set_angular_speed(double angular_speed);
    double get_angle_from_center() const;
    void set_angle_from_center(double angle_from_center);
    double get_initial_angle() const;
    bool is_clockwise() const;
    void set_clockwise(bool clockwise);
    uint32_t get_duration() const;
    void set_duration(uint32_t duration);
    int get_max_rotations() const;
    void set_max_rotations(int max_rotations);
    uint32_t get_loop() const;
    void set_loop(uint32_t delay);
    double get_angle() const override;
    int get_displayed_direction4() const override;

    const std::string& get_lua_type_name() const override;

  private:

    void recompute_position();

    // Center of the circle.
    EntityPtr center_entity;                        /**< The entity to make circles around (nullptr if only a point is used). */
    Point center_point;                             /**< Absolute coordinates of the center if only a point is used,
                                                     * or coordinates relative to the center entity otherwise. */

    // Angle.
    double current_angle;                           /**< Current angle in the circle in radians. */
    double initial_angle;                           /**< The first circle starts from this angle in radians. */
    int angle_increment;                            /**< Number of degrees to add when the angle changes (1 or -1). */
    double next_angle_change_date;                  /**< Date when the angle changes. */
    double angle_change_delay;                      /**< If not zero, time interval of an angle change of 1 degree. */
    double angular_speed;                           /**< Speed of the angle change in radians per second. */

    // Radius.
    int current_radius;                             /**< Current radius of the circle in pixels. */
    int wanted_radius;                              /**< The current radius changes gradually towards this wanted value. */
    int previous_radius;                            /**< Radius before the movement stops. */
    int radius_increment;                           /**< Number of pixels to add when the radius is changing (1 or -1). */
    uint32_t next_radius_change_date;               /**< Date of the next radius change. */
    uint32_t radius_change_delay;                   /**< If not zero, time interval between two radius changes. */

    // Stop after an amount of time.
    uint32_t duration;                              /**< If not zero, the movement will stop after this delay. */
    uint32_t end_movement_date;                     /**< Date when the movement stops. */

    // Stop after a number of rotations.
    int max_rotations;                              /**< If not zero, the movement will stop after this number of rotations are done. */
    int num_increments;                             /**< Number of 1-degree increments already done in the current circle. */
    int num_rotations;                              /**< Number of complete circles already done. */

    // Restart when stopped.
    uint32_t loop_delay;                            /**< If not zero, when the movement finishes, it will start again after this delay. */
    uint32_t restart_date;                          /**< Date when the movement restarts. */

};

}

#endif
